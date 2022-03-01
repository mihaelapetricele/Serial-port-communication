----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2021 12:32:15 AM
-- Design Name: 
-- Module Name: receiver - Behavioral
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

entity receiver is
    generic(BAUD_CLK_TICKS_RX : integer := 54); -- (freceventa / rata) / 16  => (100_000_000 / 115 200) / 16 = 54.25
    Port( RX_Data_in: in STD_LOGIC;
          Clk: in STD_LOGIC;
          Rst: in STD_LOGIC;
          RX_Data: out STD_LOGIC_VECTOR(7 downto 0));
end receiver;

architecture Behavioral of receiver is
signal baud_enx16: STD_LOGIC := '0';
signal RxStoredData: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

type state is (idle, start, bit, stop);
signal stare: state := idle;

begin

baud_rate_clk_generator: process(clk)
 variable baud_count: integer range 0 to (BAUD_CLK_TICKS_RX - 1) := (BAUD_CLK_TICKS_RX - 1);
 
 begin
 if rising_edge(Clk) then
    if (Rst = '1') then
        baud_enx16 <= '0';
        baud_count := (BAUD_CLK_TICKS_RX - 1);
    else
        if (baud_count = 0) then
            baud_enx16 <= '1';
            baud_count := (BAUD_CLK_TICKS_RX - 1);
        else
            baud_enx16 <= '0';
            baud_count := baud_count - 1;
        end if;
    end if;
 end if;
 end process baud_rate_clk_generator;

--Automat de stare pentru receptor
 FSM_RX: process(Clk)
 variable Bit_Cnt: INTEGER range 0 to 7 := 0;
 variable Baud_Cnt: INTEGER range 0 to 15 := 0;
 begin
     if rising_edge(Clk) then
         if Rst = '1' then
             stare <= idle;
             RxStoredData <= (others => '0');
             RX_Data <= (others => '0');
             Baud_Cnt := 0;
             Bit_Cnt := 0;
         else
            if baud_enx16 = '1' then
                    case stare is
                        when idle =>
                            RxStoredData <= (others => '0');
                            Baud_Cnt := 0;
                            Bit_Cnt := 0;
                            if RX_Data_in = '0' then
                                stare <= start;
                            end if;
                        when start =>
                            if RX_Data_in = '0' then
                                if Baud_Cnt = 7 then
                                    Baud_Cnt := 0;
                                    stare <= bit;
                                else
                                    Baud_Cnt := Baud_Cnt + 1;
                                end if;
                            else
                                stare <= idle;
                            end if;
                        when bit =>
                            if Baud_Cnt = 15 then
                                RxStoredData(Bit_Cnt) <= RX_Data_in;
                                Baud_Cnt := 0;
                                if Bit_Cnt = 7 then
                                    stare <= stop;
                                    Baud_Cnt := 0;
                                else
                                    Bit_Cnt := Bit_Cnt + 1;
                                end if;
                             else   
                                Baud_Cnt := Baud_Cnt + 1;
                             end if;
                         when stop =>
                            if Baud_Cnt = 15 then
                                RX_Data <= RxStoredData;
                                stare <= idle;
                            else 
                                Baud_Cnt := Baud_Cnt + 1;
                            end if;
                         when others => 
                            stare <= idle;    
                    end case;
               end if;
        end if;
     end if;
 end process FSM_RX;
end Behavioral;
