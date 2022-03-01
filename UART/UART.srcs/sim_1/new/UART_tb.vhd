----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2021 09:48:49 PM
-- Design Name: 
-- Module Name: UART_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART_tb is
--  Port ( );
end UART_tb;

architecture Behavioral of UART_tb is
signal Clk: STD_LOGIC;
signal Rst: STD_LOGIC := '0';
signal Start: STD_LOGIC := '0';
signal RX: STD_LOGIC := '0';
signal TX: STD_LOGIC := '0';
signal DataIn: STD_LOGIC_VECTOR(7 downto 0) := X"00";
signal DataOut: STD_LOGIC_VECTOR(7 downto 0) := X"00";

constant CLK_PERIOD : TIME := 10 ns;

begin
                                      
 DUT: entity WORK.UART port map( DataIn => DataIn,
                                 Clk => Clk,
                                 Rst => Rst,
                                 Start => Start,
                                 DataOut => DataOut,
                                 RX => RX,
                                 TX => TX);  
RX <= TX;                                 
gen_clk: process
        begin
            Clk <= '0';
            wait for (CLK_PERIOD/2);
            Clk <= '1';
            wait for (CLK_PERIOD/2);
end process gen_clk;

test: process
begin
    
    DataIn <= X"50"; --P
    Start <= '1';
    wait for 100 us;
    Start <= '0';
    wait for 125 us;
    
    DataIn <= X"52"; --R
    Start <= '1';
    wait for 100 us;
    Start <= '0';
    wait for 125 us;
    
    DataIn <= X"4f"; --O
    Start <= '1';
    wait for 100 us;
    Start <= '0';
    wait for 125 us;
    
    DataIn <= X"49"; --I
    Start <= '1';
    wait for 100 us;
    Start <= '0';
    wait for 125 us;
    
    DataIn <= X"45"; --E
    Start <= '1';
    wait for 100 us;
    Start <= '0';
    wait for 125 us;
    
    DataIn <= X"43"; --C
    Start <= '1';
    wait for 100 us;
    Start <= '0';
    wait for 125 us;
    
    DataIn <= X"54"; --T
    Start <= '1';
    wait for 100 us;
    Start <= '0';
    wait for 125 us;
    
end process test;

end Behavioral;
