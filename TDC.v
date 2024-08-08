module tdc (
    input wire clk,          // Reloj del sistema
    input wire start,        // Señal de inicio
    input wire stop,         // Señal de paro
    output reg [31:0] coarse_time, // Tiempo coarse medido en ciclos de reloj
    output reg [31:0] fine_time1,  // Primer tiempo fino (start to clk)
    output reg [31:0] fine_time2   // Segundo tiempo fino (clk to stop)
);

    // Registro de capturas intermedias
    reg [31:0] carry_chain_start_clk;
    reg [31:0] carry_chain_clk_stop;

    reg [31:0] carry_chain_temp;

    // Contador de ciclos de reloj para el tiempo coarse
    reg [31:0] coarse_counter;

    // Estatus de las señales de inicio y stop para detectar flancos
    reg start_detected;
    reg stop_detected;

    // Cadena de CARRY4s para el tiempo fino
    wire [31:0] carry_chain;

    // Instanciar 8 bloques de CARRY4 para crear una cadena de 32 bits
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_chain_gen
            if (i == 0) begin
                CARRY4 carry4_inst (
                    .CI(start),              // El primer CARRY4 inicia con el start
                    .DI(4'b0),
                    .S(4'b1111),
                    .O(),
                    .CO(carry_chain[3:0])
                );
            end else begin
                CARRY4 carry4_inst (
                    .CI(carry_chain[(i-1)*4+3]),  // Conecta a la salida del anterior
                    .DI(4'b0),
                    .S(4'b1111),
                    .O(),
                    .CO(carry_chain[i*4+3:i*4])
                );
            end
        end
    endgenerate

    // Lógica de control para capturar tiempos coarse y fine
    always @(posedge clk or posedge start or posedge stop) begin
        if (start) begin
            // Inicializar el contador coarse y resetear las señales
            coarse_counter <= 0;
            start_detected <= 1;
            stop_detected <= 0;
        end else if (stop) begin
            // Capturar el tiempo coarse cuando llega la señal de stop
            if (start_detected) begin
                coarse_time <= coarse_counter;
                stop_detected <= 1;
            end
        end else if (start_detected && !stop_detected) begin
            // Incrementar el contador coarse en cada ciclo de reloj
            coarse_counter <= coarse_counter + 1;
        end
    end

    // Capturar tiempos finos
    always @(posedge clk) begin
        if (start_detected && !stop_detected) begin
            carry_chain_start_clk <= carry_chain;
        end else if (stop_detected) begin
            carry_chain_clk_stop <= carry_chain;
        end
    end

    // Calcular tiempos finos en base a las capturas
    always @(posedge stop) begin
        if (start_detected && stop_detected) begin
            fine_time1 <= carry_chain_start_clk;
            fine_time2 <= carry_chain_clk_stop;
        end
    end

endmodule
