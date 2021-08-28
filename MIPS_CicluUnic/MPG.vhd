----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/23/2021 05:04:52 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MPG is
   port(btn:in std_logic;
        clk:in std_logic;
        enable:out std_logic);
end MPG;

architecture Behavioral of MPG is
signal count:STD_LOGIC_VECTOR(15 downto 0):="0000000000000000";
signal q1,q2,q3:std_logic;
begin
    process(clk)
    begin
    if(clk ='1' and clk'event) then
       count<= count+1;
    end if;
    end process;
   
    process(clk)
    begin
    if(clk='1' and clk'event) then
     if(count="1111111111111111") then
        q1<=btn;
     end if;
     end if;
     end process;
     
     process(clk)
     begin
     if(clk='1' and clk'event) then
         q2<=q1;
         q3<=q2;
     end if;
     end process;
     
     enable <= not(q3) and q2;
     
     
end Behavioral;
