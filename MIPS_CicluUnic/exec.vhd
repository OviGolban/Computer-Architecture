----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2021 04:29:53 PM
-- Design Name: 
-- Module Name: exec - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity exec is
    Port (instr:in std_logic_vector(15 downto 0);
          aluIn1:in std_logic_vector(15 downto 0);
         
          rd2:in std_logic_vector(15 downto 0);
          extImm:in std_logic_vector(15 downto 0);
          func:in std_logic_vector(2 downto 0);
          sa:in std_logic;
          aluSrc:in std_logic;
          aluOp:in std_logic_vector(2 downto 0);
          aluRes:out std_logic_vector(15 downto 0);
          branchAddress:out std_logic_vector(15 downto 0);
          zero:out std_logic
           );
end exec;

architecture Behavioral of exec is
signal aluIn2:std_logic_vector(15 downto 0);
signal aluCtrl:std_logic_vector(2 downto 0);
signal aluRezultatInter:std_logic_vector(15 downto 0);
begin
    process(aluSrc)
        begin
        if(aluSrc='0') then
            aluIn2<=rd2;
        else
            aluIn2<=extImm;
        end if;
    end process;
    
    process(aluOp,func)
    begin
        case(aluOp) is
        when "000"=>
            case(func) is
            when"000"=>aluCtrl<="000"; --add
            when"001"=>aluCtrl<="100"; --sub
            when"010"=>aluCtrl<="110"; --sll
            when"011"=>aluCtrl<="111"; --srl
            when"100"=>aluCtrl<="001"; --and
            when"101"=>aluCtrl<="010"; --or
            when"110"=>aluCtrl<="011"; --xor
            when"111"=>aluCtrl<="101"; --mult
            when others =>ALUCtrl<=(others=>'X'); --necunoscut
            end case;
       when"001"=>aluCtrl<="000";--addi
       when"010"=>aluCtrl<="000";--lw
       when"011"=>aluCtrl<="000";--sw
       when"100"=>aluCtrl<="100";--bew
       when"101"=>aluCtrl<="000";--lb
       when"110"=>aluCtrl<="000";--sb
       when"111"=>aluCtrl<="000";--jump
       when others => ALUCtrl<=(others=>'X');  --necunoscut
       end case;
   end process;
   
   process(aluIn1, aluIn2, sa, aluCtrl)
   begin
   case(aluCtrl) is
        when "000"=>aluRezultatInter<=aluIn1 + aluIn2;
        when "001"=>aluRezultatInter<=aluIn1 and aluIn2;
        when "010"=>aluRezultatInter<=aluIn1 or aluIn2;
        when "011"=>aluRezultatInter<=aluIn1 xor aluIn2;
        when "100"=>aluRezultatInter<=aluIn1 - aluIn2;
        when "101"=>aluRezultatInter<=aluIn1(7 downto 0) * aluIn2(7 downto 0);
        when "110"=>if(sa='0') then
                    aluRezultatInter<=aluIn1(14 downto 0) & '0';
                    else
                    aluRezultatInter<=aluIn1(13 downto 0) & "00";
                    end if;
        when "111"=>if(sa='0') then
                    aluRezultatInter<=aluIn1(14 downto 0) & '0';
                    else
                    aluRezultatInter<=aluIn1(13 downto 0) & "00";
                    end if;
       when others=>aluRezultatInter<=(others=>'X');
   end case;
   if(aluRezultatInter=x"0000") then
        zero<='1';
   end if;
   aluRes<=aluRezultatInter;
   end process;
   
end Behavioral;
