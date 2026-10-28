; Replay tagged events into a four-element circular buffer.
; Tag 0 events are ignored, including their payloads. Tag 1 events append
; their payload and evict the oldest element when the cursor wraps.
; The ring stores the array, next cursor and a running total in a named struct.
;
; Accepted payloads: 5, -2, 7, 3, 11, -4, 6.
; Final physical slots: [11, -4, 6, 3], cursor: 3, total: 16.
; Weighted checksum: 11*1 + (-4)*2 + 6*3 + 3*4 = 33.
; Expected exit status: checksum + total*4 + cursor = 100.
;
; Exercises arrays of named structs, nested dynamic GEP, negative pointer
; indexing, global aggregate data, stack locals, loops, both sides of branches,
; several helper calls and mutation of shared memory across calls.

%Event = type { i64, i64 }
%Ring = type { [4 x i64], i64, i64 }

@ring_state = global %Ring {
  [4 x i64] [i64 0, i64 0, i64 0, i64 0], i64 0, i64 0
}

@events = global [9 x %Event] [
  %Event { i64 1, i64 5 },
  %Event { i64 0, i64 99 },
  %Event { i64 1, i64 -2 },
  %Event { i64 1, i64 7 },
  %Event { i64 1, i64 3 },
  %Event { i64 1, i64 11 },
  %Event { i64 0, i64 -100 },
  %Event { i64 1, i64 -4 },
  %Event { i64 1, i64 6 }
]

define void @ring_push(%Ring* %ring, i64 %value) {
  %cursor_ptr = getelementptr %Ring, %Ring* %ring, i64 0, i32 1
  %total_ptr = getelementptr %Ring, %Ring* %ring, i64 0, i32 2
  %cursor = load i64, i64* %cursor_ptr
  %slot = getelementptr %Ring, %Ring* %ring, i64 0, i32 0, i64 %cursor
  %old = load i64, i64* %slot
  %total = load i64, i64* %total_ptr
  %without_old = sub i64 %total, %old
  %new_total = add i64 %without_old, %value
  store i64 %value, i64* %slot
  store i64 %new_total, i64* %total_ptr
  %next = add i64 %cursor, 1
  %wrap = icmp eq i64 %next, 4
  br i1 %wrap, label %wrapped, label %advance
wrapped:
  store i64 0, i64* %cursor_ptr
  ret void
advance:
  store i64 %next, i64* %cursor_ptr
  ret void
}

define void @replay(%Ring* %ring, %Event* %first, i64 %count) {
  %index_ptr = alloca i64
  store i64 0, i64* %index_ptr
  br label %loop
loop:
  %index = load i64, i64* %index_ptr
  %more = icmp slt i64 %index, %count
  br i1 %more, label %inspect, label %done
inspect:
  %tag_ptr = getelementptr %Event, %Event* %first, i64 %index, i32 0
  %tag = load i64, i64* %tag_ptr
  %accepted = icmp eq i64 %tag, 1
  br i1 %accepted, label %append, label %advance
append:
  %value_ptr = getelementptr %Event, %Event* %first, i64 %index, i32 1
  %value = load i64, i64* %value_ptr
  call void @ring_push(%Ring* %ring, i64 %value)
  br label %advance
advance:
  %next = add i64 %index, 1
  store i64 %next, i64* %index_ptr
  br label %loop
done:
  ret void
}

define i64 @checksum(%Ring* %ring) {
  %last = getelementptr %Ring, %Ring* %ring, i64 0, i32 0, i64 3
  %first = getelementptr i64, i64* %last, i64 -3
  %index_ptr = alloca i64
  %sum_ptr = alloca i64
  store i64 0, i64* %index_ptr
  store i64 0, i64* %sum_ptr
  br label %loop
loop:
  %index = load i64, i64* %index_ptr
  %more = icmp slt i64 %index, 4
  br i1 %more, label %body, label %done
body:
  %slot = getelementptr i64, i64* %first, i64 %index
  %value = load i64, i64* %slot
  %weight = add i64 %index, 1
  %weighted = mul i64 %value, %weight
  %sum = load i64, i64* %sum_ptr
  %updated = add i64 %sum, %weighted
  store i64 %updated, i64* %sum_ptr
  store i64 %weight, i64* %index_ptr
  br label %loop
done:
  %result = load i64, i64* %sum_ptr
  ret i64 %result
}

define i64 @main(i64 %argc, i8** %argv) {
  %ring = bitcast %Ring* @ring_state to %Ring*
  %index_ptr = alloca i64
  store i64 0, i64* %index_ptr
  br label %initialize
initialize:
  %index = load i64, i64* %index_ptr
  %more = icmp slt i64 %index, 4
  br i1 %more, label %clear, label %run
clear:
  %slot = getelementptr %Ring, %Ring* %ring, i64 0, i32 0, i64 %index
  store i64 0, i64* %slot
  %next = add i64 %index, 1
  store i64 %next, i64* %index_ptr
  br label %initialize
run:
  %cursor_ptr = getelementptr %Ring, %Ring* %ring, i64 0, i32 1
  %total_ptr = getelementptr %Ring, %Ring* %ring, i64 0, i32 2
  store i64 0, i64* %cursor_ptr
  store i64 0, i64* %total_ptr
  %first = getelementptr [9 x %Event], [9 x %Event]* @events, i64 0, i64 0
  call void @replay(%Ring* %ring, %Event* %first, i64 9)
  ; Replaying zero events must leave the completed buffer unchanged.
  call void @replay(%Ring* %ring, %Event* %first, i64 0)
  %weighted_sum = call i64 @checksum(%Ring* %ring)
  %total = load i64, i64* %total_ptr
  %cursor = load i64, i64* %cursor_ptr
  %scaled_total = mul i64 %total, 4
  %combined = add i64 %weighted_sum, %scaled_total
  %result = add i64 %combined, %cursor
  ret i64 %result
}
