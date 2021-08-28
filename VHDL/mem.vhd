----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2021 07:31:23 PM
-- Design Name: 
-- Module Name: mem - Behavioral
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
Library UNISIM;
use UNISIM.vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity mem is
  Port (ra:in std_logic_vector(3 downto 0);
    wa:in std_logic_vector(3 downto 0);
    wd:in std_logic_vector(15 downto 0);
    rd:out std_logic_vector(15 downto 0);
    wrEnable:in std_logic;
    clk:in std_logic );
end mem;

architecture Behavioral of mem is
type ram_type is array(0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
signal ram: ram_type:=(
        X"0000",
        X"0001",
        X"0002",
        X"0003",
        X"0004",
        X"0005",
        X"0006",
        X"0007",
        others => X"0000");
        

begin
    process(clk)
    begin
        if(clk ='1' and clk'event) then
            if(wrEnable='1') then
            ram(conv_integer(wa))<= wd;
            end if;
        end if;
    end process;
rd<= ram(conv_integer(ra));



end Behavioral;
