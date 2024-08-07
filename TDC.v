module tdc (
    input wire start,         // Señal de inicio
    input wire stop,          // Señal de paro
    output reg [31:0] tdc_out // Salida del TDC, 32 bits para 8 bloques CARRY4
);

wire [31:0] carry_chain; // Señal intermedia para conectar los bloques CARRY4

// Primer bloque CARRY4
CARRY4 carry4_0 (
    .CI(start),              // Entrada de acarreo desde la señal de inicio
    .DI(4'b0),               // Entradas directas, se mantienen en 0
    .S(4'b1111),             // Entradas del sumador, forzar acarreo
    .O(),                    // Ignorado en este caso
    .CO(carry_chain[3:0])    // Salida de acarreo, conectar al siguiente bloque
);

// Segundo bloque CARRY4
CARRY4 carry4_1 (
    .CI(carry_chain[3]),     // Conectar salida de acarreo del bloque anterior
    .DI(4'b0),
    .S(4'b1111),
    .O(),
    .CO(carry_chain[7:4])
);

// Tercer bloque CARRY4
CARRY4 carry4_2 (
    .CI(carry_chain[7]),
    .DI(4'b0),
    .S(4'b1111),
    .O(),
    .CO(carry_chain[11:8])
);

// Cuarto bloque CARRY4
CARRY4 carry4_3 (
    .CI(carry_chain[11]),
    .DI(4'b0),
    .S(4'b1111),
    .O(),
    .CO(carry_chain[15:12])
);

// Quinto bloque CARRY4
CARRY4 carry4_4 (
    .CI(carry_chain[15]),
    .DI(4'b0),
    .S(4'b1111),
    .O(),
    .CO(carry_chain[19:16])
);

// Sexto bloque CARRY4
CARRY4 carry4_5 (
    .CI(carry_chain[19]),
    .DI(4'b0),
    .S(4'b1111),
    .O(),
    .CO(carry_chain[23:20])
);

// Séptimo bloque CARRY4
CARRY4 carry4_6 (
    .CI(carry_chain[23]),
    .DI(4'b0),
    .S(4'b1111),
    .O(),
    .CO(carry_chain[27:24])
);

// Octavo bloque CARRY4
CARRY4 carry4_7 (
    .CI(carry_chain[27]),
    .DI(4'b0),
    .S(4'b1111),
    .O(),
    .CO(carry_chain[31:28])
);

// Captura de la señal de la línea de retardo cuando se activa la señal de paro
always @(posedge stop) begin
    tdc_out <= carry_chain;
end

endmodule
