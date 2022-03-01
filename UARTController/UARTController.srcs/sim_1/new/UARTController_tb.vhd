----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/23/2021 03:29:00 PM
-- Design Name: 
-- Module Name: UARTController_tb - Behavioral
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

entity UARTController_tb is
--  Port ( );
end UARTController_tb;

architecture Behavioral of UARTController_tb is
signal DataIn: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal Clk: STD_LOGIC;
signal Rst: STD_LOGIC := '0';
signal Enable: STD_LOGIC := '0';
--signal DataOut: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal RX : STD_LOGIC;
signal TX : STD_LOGIC;
signal An : STD_LOGIC_VECTOR(7 downto 0);
signal Seg : STD_LOGIC_VECTOR(7 downto 0);
constant CLK_PERIOD : TIME := 10 ns;

begin

UARTController: entity WORK.UARTController port map( DataIn => DataIn,
                                 Clk => Clk,
                                 Rst => Rst,
                                 Enable => Enable,
                                 RX => RX,
                                 TX => TX,
                                 An => An,
                                 Seg => Seg);  
                                 
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
    
    DataIn <= X"53"; --S
    wait for 30 us;
    Enable <= '1';
    wait for 100 us;
    Enable <= '0';
    wait for 125 us;
    
    DataIn <= X"45"; --E
    Enable <= '0';
    wait for 30 us;
    Enable <= '1';
    wait for 100 us;
    Enable <= '0';
    wait for 125 us;
    
    DataIn <= X"52"; --R
    wait for 30 us;
    Enable <= '1';
    wait for 100 us;
    Enable <= '0';
    wait for 125 us;
    
    DataIn <= X"49"; --I
    Enable <= '1';
    wait for 100 us;
    Enable <= '0';
    wait for 125 us;
    
    DataIn <= X"41"; --A
    Enable <= '1';
    wait for 100 us;
    Enable <= '0';
    wait for 125 us;
    
    DataIn <= X"4C"; --L
    Enable <= '1';
    wait for 100 us;
    Enable <= '0';
    wait for 125 us;
    
end process test;
end Behavioral;
