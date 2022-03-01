----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2021 02:06:31 PM
-- Design Name: 
-- Module Name: transmitter_tb - Behavioral
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

entity transmitter_tb is
--  Port ( );
end transmitter_tb;

architecture Behavioral of transmitter_tb is

signal Data: STD_LOGIC_VECTOR(7 downto 0) := X"00";
signal Clk: STD_LOGIC;
signal Rst: STD_LOGIC := '0';
signal TX_EN: STD_LOGIC := '0';
signal TX_Data: STD_LOGIC := '0';
constant CLK_PERIOD : TIME := 10 ns;
       
begin

DUT: entity WORK.transmitter port map(Data => Data,
                                      Clk => Clk,
                                      Rst => Rst,
                                      TX_EN => TX_EN,
                                      TX_Data => TX_Data);
gen_clk: process
        begin
            Clk <= '0';
            wait for (CLK_PERIOD/2);
            Clk <= '1';
            wait for (CLK_PERIOD/2);
end process gen_clk; 

test: process
begin

    Data <= X"48";
    TX_EN <= '1';
    wait for 100 us;
    TX_EN <= '0';
    wait for 125 us;
    
    Data <= X"45";
    TX_EN <= '1';
    wait for 100 us;
    TX_EN <= '0';
    wait for 125 us;
    
    wait for 300 ns;
    
    Data <= X"4C";
    TX_EN <= '1';
    wait for 100 us;
    TX_EN <= '0';
    wait for 125 us;
    
    Data <= X"4C";
    TX_EN <= '1';
    wait for 100 us;
    TX_EN <= '0';
    wait for 125 us;
    
    Data <= X"4F";
    TX_EN <= '1';
    wait for 100 us;
    TX_EN <= '0';
    wait for 125 us;
    
end process test;
end Behavioral;
