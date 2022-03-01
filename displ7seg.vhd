----------------------------------------------------------------------------
-- Nume proiect: clock
-- Nume modul:   displ7seg_blink
-- Descriere:    Multiplexor pentru afisajul cu sapte segmente, cu
--               posibilitatea palpairii cifrelor. Datele de intrare nu
--               sunt decodificate, ci sunt aplicate direct la segmentele
--               afisajului. Pentru afisarea valorilor hexazecimale,
--               codul fiecarei cifre trebuie aplicat la intrarea Data
--               prin intermediul functiei de conversie HEX2SSEG. Pentru
--               afisarea unei cifre cu palpaire, bitul 7 al codului cifrei
--               trebuie setat la 1.
--               Codificarea segmentelor (biti 7..0): 0GFE DCBA
--                   A
--                  ---  
--               F |   | B
--                  ---    <- G
--               E |   | C
--                  --- 
--                   D
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity displ7seg is
   Port ( Clk  : in  STD_LOGIC;
          Rst  : in  STD_LOGIC;
          Data : in  STD_LOGIC_VECTOR (31 downto 0); 
                 -- date de afisat (cifra 1 din stanga: biti 63..56)
          An   : out STD_LOGIC_VECTOR (7 downto 0); 
                 -- semnale pentru anozi (active in 0 logic)
          Seg  : out STD_LOGIC_VECTOR (7 downto 0)); 
                 -- semnale pentru segmentele (catozii) cifrei active
end displ7seg;

architecture Behavioral of displ7seg is

constant CLK_RATE  : INTEGER := 100_000_000;  -- frecventa semnalului Clk
constant CNT_100HZ : INTEGER := 2**20;        -- divizor pentru rata de
                                              -- reimprospatare de ~100 Hz
constant CNT_500MS : INTEGER := CLK_RATE / 2; -- divizor pentru 500 ms
signal Count       : INTEGER range 0 to CNT_100HZ - 1 := 0;
signal CountBlink  : INTEGER range 0 to CNT_500MS - 1 := 0;
signal BlinkOn     : STD_LOGIC := '0';
signal CountVect   : STD_LOGIC_VECTOR (19 downto 0) := (others => '0');
signal LedSel      : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal Digit      : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');


begin
   -- Proces pentru divizarea frecventei ceasului
   div_clk: process (Clk)
   begin
      if RISING_EDGE (Clk) then
         if (Rst = '1') then
            Count <= 0;
         elsif (Count = CNT_100HZ - 1) then
            Count <= 0;
         else
            Count <= Count + 1;
         end if;
      end if;
   end process div_clk;

   CountVect <= CONV_STD_LOGIC_VECTOR (Count, 20);
   LedSel <= CountVect (19 downto 17);

   -- Semnal pentru selectarea cifrei active (anozi)
   An <= "11111110" when LedSel = "000" else
         "11111101" when LedSel = "001" else
         "11111011" when LedSel = "010" else
         "11110111" when LedSel = "011" else
         "11101111" when LedSel = "100" else
         "11011111" when LedSel = "101" else
         "10111111" when LedSel = "110" else
         "01111111" when LedSel = "111" else
         "11111111";
         
  Digit <= Data (3  downto  0) when LedSel = "000" else
           Data (7  downto  4) when LedSel = "001" else
           Data (11 downto  8) when LedSel = "010" else
           Data (15 downto 12) when LedSel = "011" else
           Data (19 downto 16) when LedSel = "100" else
           Data (23 downto 20) when LedSel = "101" else
           Data (27 downto 24) when LedSel = "110" else
           Data (31 downto 28) when LedSel = "111" else
           X"0";
           
   -- Semnal pentru segmentele cifrei active (catozi)
   Seg <=  "11111001" when Digit = "0001" else           
           "10100100" when Digit = "0010" else            
           "10110000" when Digit = "0011" else           
           "10011001" when Digit = "0100" else            
           "10010010" when Digit = "0101" else            
           "10000010" when Digit = "0110" else            
           "11111000" when Digit = "0111" else           
           "10000000" when Digit = "1000" else            
           "10010000" when Digit = "1001" else            
           "10001000" when Digit = "1010" else            
           "10000011" when Digit = "1011" else            
           "11000110" when Digit = "1100" else            
           "10100001" when Digit = "1101" else            
           "10000110" when Digit = "1110" else           
           "10001110" when Digit = "1111" else            
           "11000000";                                  

end Behavioral;
