module pulse_generator (
    input wire clk,         // Reloj de entrada
    input wire trigger,     // Señal de activación
    input wire [7:0] N,    // Número de ciclos de separación
    output reg pulse1,      // Primer pulso
    output reg pulse2       // Segundo pulso
);

    reg [31:0] counter;     // Contador para la separación de los pulsos
    reg active;             // Señal para indicar que la secuencia está activa
    reg   Q1,Q2,Q3;
    always @(posedge clk or posedge int_trigger) begin
        if (int_trigger) begin
            // Reiniciar la secuencia cuando se detecta el flanco de subida del trigger
            pulse1 <= 1;
            pulse2 <= 0;
            counter <= 0;   // Iniciar el contador en 0
            active <= 1;
        end else if (active) begin
            // Continuar con la secuencia
            if (counter == 0) begin
                pulse1 <= 0;  // Finalizar el primer pulso en el primer ciclo
            end

            if (counter == N) begin
                pulse2 <= 1;  // Generar el segundo pulso
            end else if (counter == N + 1) begin
                pulse2 <= 0;  // Finalizar el segundo pulso
                active <= 0;  // Desactivar la secuencia
            end

            counter <= counter + 1;  // Incrementar el contador
        end else begin
            // Mantener las salidas en 0 cuando no hay secuencia activa
            pulse1 <= 0;
            pulse2 <= 0;
        end
    end
    always @(posedge clk)
        begin
      Q1 <= trigger; 
      Q2 <= Q1;
      Q3 <= Q2;
    end
assign int_trigger = Q1 && Q2 && (~ Q3);

endmodule
