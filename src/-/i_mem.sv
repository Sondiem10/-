/*module i_mem(
    input [31:0] adr,
    output [31:0] ins
);
    reg [7:0] rom_array [1023:0]; 
	initial begin
        $readmemh("F:/modeltech64_2020.4/examples/program.txt", rom_array);      
		//$readmemb("F:/RISCV/bubble_sort.bin",rom_array);
    end

    wire [9:0] addr;
    assign addr = adr[9:0];
    assign ins = { rom_array[addr], rom_array[addr+1], rom_array[addr+2],rom_array[addr+3]};

endmodule*/
module i_mem(
    input [31:0] adr,
    output [31:0] ins
);
    reg [7:0] rom_array [1023:0]; 
    integer file;
    integer read_count; // THÊM: Biến lưu số lượng byte đọc được

    initial begin
        // Khởi tạo bộ nhớ bằng 0 để tránh lỗi rác
        for (int i = 0; i < 1024; i = i + 1) rom_array[i] = 8'h00;
        
        // Mở file ở chế độ đọc nhị phân ("rb")
        file = $fopen("F:/RISCV/bubble_sort.bin", "rb");
        if (file) begin
            // SỬA: Bắt giá trị trả về của $fread vào biến read_count
            read_count = $fread(rom_array, file); 
            
            // Tùy chọn: In ra màn hình để debug xem đọc được bao nhiêu byte
            $display("Da doc thanh cong %0d bytes tu file bubble_sort.bin", read_count);
            
            $fclose(file);
        end else begin
            $display("Loi: Khong the mo file bubble_sort.bin!");
        end
    end

    wire [9:0] addr;
    assign addr = adr[9:0];
    assign ins = { rom_array[addr+3], rom_array[addr+2], rom_array[addr+1], rom_array[addr] };

endmodule
