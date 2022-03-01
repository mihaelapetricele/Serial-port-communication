----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2021 10:41:27 PM
-- Design Name: 
-- Module Name: transmitter - Behavioral
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

entity transmitter is
    generic(BAUD_CLK_TICKS: INTEGER := 868); -- frecventa/rata(100_000_000 / 115 200 = 868.0555)
    Port( Data: in STD_LOGIC_VECTOR(7 downto 0);
          Clk: in STD_LOGIC;
          Rst: in STD_LOGIC;
          TX_EN: in STD_LOGIC;
          TX: out STD_LOGIC
              );
end transmitter;

architecture Behavioral of transmitter is

signal baud_en: STD_LOGIC:= '0';
signal dataIndex : INTEGER range 0 to 7;
signal dataIndexRst: STD_LOGIC := '1';
signal storedData: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal startDetected: STD_LOGIC := '0';
signal startRst: STD_LOGIC := '0';
    
type state is (idle, start, bit, stop);
signal stare: state := idle;
signal S_TX: STD_LOGIC;

begin
 baud_rate_clk_generator: process(clk)
 variable baud_count: integer range 0 to (BAUD_CLK_TICKS - 1) := (BAUD_CLK_TICKS - 1);
 
 begin
 if rising_edge(Clk) then
    if (Rst = '1') then
        baud_en <= '0';
        baud_count := (BAUD_CLK_TICKS - 1);
    else
        if (baud_count = 0) then
            baud_en <= '1';
            baud_count := (BAUD_CLK_TICKS - 1);
        else
            baud_en <= '0';
            baud_count := baud_count - 1;
        end if;
    end if;
 end if;
 end process baud_rate_clk_generator;
 
 --proces pentru generarea semnalului startDetected
 
TX_En_detector: process(Clk)
    begin
        if rising_edge(Clk) then
            if (Rst ='1') or (startRst = '1') then
                startDetected <= '0';
            else
                if (TX_EN = '1') and (startDetected = '0') then
                    startDetected <= '1';
                    storedData <= Data;
                end if;
            end if;
        end if;
    end process TX_En_detector; 
    
 --numarator care numara frecventa baud_rate
 
 data_index_counter: process(Clk)
 begin
        if rising_edge(Clk) then
            if (Rst = '1') or (dataIndexRst = '1') then
                dataIndex <= 0;
            elsif (baud_en = '1') then
                dataIndex <= dataIndex + 1;
            end if;
        end if;
 end process data_index_counter;
 
 --Automat de stare pentru transmitator
 FSM_TX: process(Clk)
 begin
    if rising_edge(clk) then
         if Rst = '1' then
               stare <= idle;
               dataIndexRst <= '1';
               startRst <= '1';
               TX <= '1';
         else
            if baud_en = '1' then
                 case stare is
                        when idle =>
                            dataIndexRst <= '1';
                            startRst <= '0';
                            TX <= '1';
                            
                            if startDetected = '1' then
                                stare <= start;
                            end if;
                        when start =>
                            dataIndexRst <= '0';
                            TX <= '0';
                            stare <= bit;
                        when bit =>
                            TX <= storedData(dataIndex);  
                            --dataIndex = 7 => toti bitii au fost transmisi si putem merge la starea stop
                            if dataIndex = 7 then
                                dataIndexRst <= '1';
                                stare <= stop;
                            end if;
                         when stop =>
                            TX <= '1';
                            startRst <= '1';
                            stare <= idle; 
                         when others => 
                            stare <= idle;    
                    end case;
                end if;
             end if;
        end if;
 end process FSM_TX;

end Behavioral;
