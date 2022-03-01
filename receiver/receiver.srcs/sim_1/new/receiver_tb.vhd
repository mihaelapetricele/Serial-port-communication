----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 12:40:26 AM
-- Design Name: 
-- Module Name: receiver_tb - Behavioral
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

entity receiver_tb is
--  Port ( );
end receiver_tb;

architecture Behavioral of receiver_tb is

signal Clk: STD_LOGIC;
signal Rst: STD_LOGIC := '0';
signal RX_Data: STD_LOGIC_VECTOR(7 downto 0) := X"00";

signal Data_tx: STD_LOGIC_VECTOR(7 downto 0) := X"00";
signal TX_EN: STD_LOGIC := '0';
signal TX_Data_S: STD_LOGIC;

constant CLK_PERIOD : TIME := 10 ns;
--constant CLK_PERIOD2 : TIME := 1 ns;

begin
DUT1: entity WORK.transmitter port map(Data => Data_tx,
                                      Clk => Clk,
                                      Rst => Rst,
                                      TX_EN => TX_EN,
                                      TX_Data => TX_Data_S);
                                      
DUT: entity WORK.receiver  port map(RX_Data_In => TX_Data_S,
                                   Clk => Clk,
                                   Rst => Rst,
                                   RX_Data => RX_Data);
                                      
                                      
gen_clk: process
        begin
            Clk <= '0';
            wait for (CLK_PERIOD/2);
            Clk <= '1';
            wait for (CLK_PERIOD/2);
end process gen_clk;
 

test: process
begin
    Data_tx <= X"48";
    TX_EN <= '1';
    wait for 100 us;
    TX_EN <= '0';
    wait for 125 us;
    
    Data_tx <= X"45";
    TX_EN <= '1';
    wait for 100 us;
    TX_EN <= '0';
    wait for 125 us;
    
    wait for 300 ns;
    
    Data_tx <= X"4C";
    TX_EN <= '1';
    wait for 100 us;
    TX_EN <= '0';
    wait for 125 us;
    
    Data_tx <= X"4C";
    TX_EN <= '1';
    wait for 100 us;
    TX_EN <= '0';
    wait for 125 us;
    
    Data_tx <= X"4F";
    TX_EN <= '1';
    wait for 100 us;
    TX_EN <= '0';
    wait for 125 us;

end process test;

end Behavioral;
