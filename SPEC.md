# G05 — Bộ tìm giá trị lớn nhất và nhỏ nhất trong tám mẫu

## 1. Mục tiêu

Thiết kế một mạch tuần tự nhận tám mẫu dữ liệu 8 bit. Mạch xác định giá trị lớn nhất (MAX) và nhỏ nhất (MIN) trong cửa sổ tám mẫu.

## 2. Giao diện dự kiến

| Tín hiệu | Chiều | Độ rộng | Chức năng |
|---|---|---:|---|
| `ui_in[7:0]` | Input | 8 bit | Mẫu dữ liệu |
| `uio_in[0]` | Input | 1 bit | Báo mẫu hợp lệ |
| `uo_out[7:0]` | Output | 8 bit | Giá trị MAX |
| `uio_out[7:0]` | Output | 8 bit | Giá trị MIN |

## 3. Nguyên tắc hoạt động

- Chỉ xử lý mẫu khi tín hiệu báo mẫu hợp lệ được bật.
- Cập nhật MAX và MIN khi nhận từng mẫu hợp lệ.
- Mỗi cửa sổ gồm tám mẫu hợp lệ.
- Sau mẫu hợp lệ thứ tám, kết quả của cửa sổ được chốt.
- Khi bắt đầu cửa sổ mới, trạng thái MAX/MIN phải được khởi tạo phù hợp để không dùng nhầm kết quả của cửa sổ trước.

## 4. Các điểm cần xác nhận trước khi viết RTL

- Cách xử lý clock và reset theo framework Tiny Tapeout.
- Cách xuất đồng thời MAX và MIN khi giao diện vật lý chỉ có 24 chân.
- Thời điểm chốt kết quả và bắt đầu cửa sổ tiếp theo.
- Cách khởi tạo MAX/MIN và bộ đếm.

## 5. Quy tắc xử lý mẫu

1. Chỉ nhận mẫu tại cạnh lên của clock khi sample_valid = 1.
2. Mỗi mẫu hợp lệ được tính đúng một lần.
3. MAX được cập nhật nếu mẫu mới lớn hơn MAX hiện tại.
4. MIN được cập nhật nếu mẫu mới nhỏ hơn MIN hiện tại.
5. Mẫu hợp lệ thứ tám phải được tính vào kết quả trước khi chốt MAX/MIN.
6. Mẫu không hợp lệ không được thay đổi MAX, MIN hoặc bộ đếm.
7. Khi bắt đầu cửa sổ mới, không được để giá trị MAX/MIN của cửa sổ trước ảnh hưởng kết quả.

## 6. Các trường hợp kiểm thử dự kiến

| STT | Tám mẫu đầu vào | MAX mong đợi | MIN mong đợi | Mục đích |
|---|---|---:|---:|---|
| 1 | 1, 2, 3, 4, 5, 6, 7, 8 | 8 | 1 | Dãy tăng |
| 2 | 8, 7, 6, 5, 4, 3, 2, 1 | 8 | 1 | Dãy giảm |
| 3 | 50, 50, 50, 50, 50, 50, 50, 50 | 50 | 50 | Các mẫu bằng nhau |
| 4 | 255, 20, 30, 40, 50, 60, 70, 80 | 255 | 20 | MAX ở mẫu đầu |
| 5 | 20, 30, 40, 50, 60, 70, 80, 0 | 80 | 0 | MIN ở mẫu cuối |
| 6 | 0, 255, 0, 255, 128, 127, 1, 254 | 255 | 0 | Kiểm tra biên 0 và 255 |
