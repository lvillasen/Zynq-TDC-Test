module pulse_generator(
    input wire clk,        // Reloj de entrada
    input wire reset,      // Señal de reinicio
    output reg pulse1,     // Primer pulso de salida
    output reg pulse2      // Segundo pulso de salida
);
    parameter N = 10;      // Espaciado deseado entre pulsos (en ciclos de reloj)

    reg [31:0] counter;    // Contador de ciclos de reloj

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            pulse1 <= 0;
            pulse2 <= 0;
        end else begin
            if (counter == 0) begin
                pulse1 <= 1; // Genera el primer pulso
            end else begin
                pulse1 <= 0;
            end

            if (counter == N) begin
                pulse2 <= 1; // Genera el segundo pulso cuando el contador alcanza N
            end else begin
                pulse2 <= 0;
            end

            // Incrementa el contador
            counter <= counter + 1;
        end
    end
endmodule
