----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/23/2021 12:46:36 AM
-- Design Name: 
-- Module Name: UARTController - Behavioral
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

entity UARTController is
    Port( DataIn: in STD_LOGIC_VECTOR(7 downto 0);
          Clk: in STD_LOGIC;
          Rst: in STD_LOGIC;
          Enable: in STD_LOGIC;
          RX: in STD_LOGIC;
          TX: out STD_LOGIC;
          An : out STD_LOGIC_VECTOR(7 downto 0);
          Seg : out STD_LOGIC_VECTOR(7 downto 0));
end UARTController;

architecture Behavioral of UARTController is
signal button : STD_LOGIC;
signal data : STD_LOGIC_VECTOR (31 downto 0):= (others =>'0');
signal DataOut: STD_LOGIC_VECTOR(7 downto 0);
begin

 DUT_debounce: entity WORK.debounce port map(Clk => Clk,
                                             Rst => Rst,
                                             Data => Enable,
                                             debounceBtn => button);

 UART: entity WORK.UART port map( DataIn => DataIn,
                                 Clk => Clk,
                                 Rst => Rst,
                                 Start => button,
                                 DataOut => DataOut,
                                 RX => RX,
                                 TX => TX);    
                               

data( 31 downto 24) <= "00000000";              
data( 23 downto 16) <= "00000000";
data( 15 downto 8) <= DataOut;                      
data( 7 downto 0) <= DataIn;                            
                               
 displ7seg: entity WORK.displ7seg port map(Clk => Clk,
          Rst => Rst,
          Data => data,
          An  => An,
          Seg => Seg);   

end Behavioral;
