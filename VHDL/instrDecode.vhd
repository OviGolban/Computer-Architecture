
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

entity instrDecode is
    port(clk:in std_logic;
        instr:in std_logic_vector(15 downto 0);
        rdAdr1:in std_logic_vector(2 downto 0);
        rdAdr2:in std_logic_vector(2 downto 0);
        wrData:in std_logic_vector(15 downto 0);
        wrAdress:in std_logic_vector(2 downto 0);
        regWrite:in std_logic;
        regDst:in std_logic;
        extOp:in std_logic;
        rd1:out std_logic_vector(15 downto 0);
        rd2:out std_logic_vector(15 downto 0);
        extImm:out std_logic_vector(15 downto 0);
        func:out std_logic_vector(2 downto 0);
        sa:out std_logic);
        
end instrDecode;

architecture Behavioral of instrDecode is
type reg_array is array(0 to 15) of std_logic_vector(15 downto 0);
signal reg_file:reg_array:=(
        X"0001",
        X"0201",
        X"2402",
        X"1003",
        X"1234",
        X"0321",
        X"0041",
        X"9907",
        others=>X"0000");

begin
    
    process(clk,regWrite,instr)
    begin
        if clk='0' and clk'event then  --scriere pe fron descrescator pt prevenirea hazardului
            if regWrite='1' then
                reg_file(conv_integer(wrAdress))<=wrData;
             end if;
        end if;
    end process;
rd1<=reg_file(conv_integer(rdAdr1));
rd2<=reg_file(conv_integer(rdAdr2));
    
    process(extOp)
    begin
        if(extOp='0') then
            extImm<=instr(6 downto 0) & "000000000";
         else
            if(instr(6)='0') then
                extImm<="000000000" & instr(6 downto 0);
            else 
                extImm<="111111111" & instr(6 downto 0);
            end if;
        end if;
    end process;
func<=instr(2 downto 0);
sa<=instr(3);

end Behavioral;
