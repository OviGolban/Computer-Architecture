----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2021 07:26:15 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
signal PCenable:std_logic;
signal reset:std_logic;
signal instruction:std_logic_vector(15 downto 0);
signal pc:std_logic_vector(15 downto 0);
signal afisare:std_logic_vector(15 downto 0);

signal regDst:std_logic;
signal extOp:std_logic;
signal ALUSrc:std_logic;
signal branch:std_logic;
signal jump:std_logic;
signal ALUOp:std_logic_vector(2 downto 0);
signal memWrite:std_logic;
signal memtoReg:std_logic;
signal regWrite:std_logic;
signal regWriteFinal:std_logic;
signal PCSrc:std_logic;

signal wrData:std_logic_vector(15 downto 0);
signal rd1:std_logic_vector(15 downto 0);
signal rd2:std_logic_vector(15 downto 0);
signal extImm:std_logic_vector(15 downto 0);
signal func:std_logic_vector(2 downto 0);
signal sa:std_logic;

signal sumaRD:std_logic_vector(15 downto 0); --TO DO:va trebui scos,nu il mai folosesc

signal aluRezultat:std_logic_vector(15 downto 0);
signal branchAddress:std_logic_vector(15 downto 0);
signal zero:std_logic;

signal wa:std_logic_vector(3 downto 0);

signal writeBack:std_logic_vector(15 downto 0);
signal memWriteMemory:std_logic;
signal memData: std_logic_vector(15 downto 0);

signal jumpAddress:std_logic_vector(15 downto 0);


component MPG is
    port(btn:in std_logic;
        clk:in std_logic;
        enable:out std_logic);
end component;

component SSD is
    Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR(6 downto 0);
           an : out STD_LOGIC_VECTOR(3 downto 0));
end component;

component instrFetch is
port(clk:in std_logic;
    branchAddress: in std_logic_vector(15 downto 0);
    jumpAddress: in std_logic_vector(15 downto 0);
    jump: in std_logic;
    PCSrc: in std_logic;
    PCenable:in std_logic;
    reset: in std_logic;
    instruction:out std_logic_vector(15 downto 0);
    pc:out std_logic_vector(15 downto 0));
end component;

component instrDecode is
    port(clk:in std_logic;
        instr:in std_logic_vector(15 downto 0);
        wrData:in std_logic_vector(15 downto 0);
        regWrite:in std_logic;
        regDst:in std_logic;
        extOp:in std_logic;
        rd1:out std_logic_vector(15 downto 0);
        rd2:out std_logic_vector(15 downto 0);
        extImm:out std_logic_vector(15 downto 0);
        func:out std_logic_vector(2 downto 0);
        sa:out std_logic);
        
end component;

component exec is
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
end component;

component mem is
  Port (ra:in std_logic_vector(3 downto 0);
    wa:in std_logic_vector(3 downto 0);
    wd:in std_logic_vector(15 downto 0);
    rd:out std_logic_vector(15 downto 0);
    wrEnable:in std_logic;
    clk:in std_logic );
end component;

begin   
MPG_map:MPG port map(btn=>btn(0),
                clk=>clk,
                enable=>PCenable);
                
MPG_map2:MPG port map(btn=>btn(1),
                     clk=>clk,
                     enable=>reset);

jumpAddress<='0' & instruction(14 downto 0);
instrFetch_map:instrFetch port map(clk=>clk,
                                    jump=>jump,
                                    jumpAddress=>jumpAddress,
                                    branchAddress=>B"000_000_000_001_0_000",
                                    PCSrc=>PCSrc,
                                    PCenable=>PCenable,
                                   reset=>reset,
                                   instruction=>instruction,
                                   pc=>pc);
                                                                      
process(instruction) --implementare UC-unitate de control
begin
regDst<='0';
extOp<='0';
ALUSrc<='0';
branch<='0';
jump<='0';
ALUOp<=instruction(15 downto 13);
memWrite<='0';
memtoReg<='0';
regWrite<='0';

case ALUOp is
when "000" => --instr de tip R
    regDst<='1';
    regWrite<='1';
when "001" => --addi
    regDst<='1';
    regWrite<='1';
    ALUSrc<='1';
when "010" => --lw
    regWrite<='1';
    ALUSrc<='1';
    extOp<='1';
    memtoreg<='1';
when "011" => --sw
    ALUSrc<='1';
    extOp<='1';
    memWrite<='1';
when "100"=> --beq
    extOp<='1';
    branch<='1';
when "101"=> --lb
    regWrite<='1';
    ALUSrc<='1';
    extOp<='1';
    memtoreg<='1';
when "110"=> --sb
    ALUSrc<='1';
    extOp<='1';
    memWrite<='1';
when "111"=> --jump
    jump<='1';
when others =>
    regDst<='0';
    extOp<='0';
    ALUSrc<='0';
    
    
end case;
end process;

      
    
                                   

sumaRD<=rd1+rd2;  
regWriteFinal<=PCEnable and regWrite;                                 
instrDecode_map: instrDecode port map(clk=>clk,
                                      instr=>instruction,
                                      wrData=>writeBack,
                                      regWrite=>regWriteFinal,
                                      regDst=>regDst,
                                      extOp=>extOp,
                                      rd1=>rd1,
                                      rd2=>rd2,
                                      extImm=>extImm,
                                      func=>func,
                                      sa=>sa);
                                      
exec_map:exec port map(instr=>instruction,
                       aluIn1=>rd1,
                       rd2=>rd2,
                       extImm=>extImm,
                       func=>func,
                       sa=>sa,
                       aluSrc=>aluSrc,
                       aluOp=>aluOp,
                       aluRes=>aluRezultat,
                       branchAddress=>branchAddress,
                       zero=>zero);
memWriteMemory<=memWrite and PCEnable;
mem_map: mem port map(ra=>aluRezultat(3 downto 0),
                      wa=>wa,
                      wd=>rd2,
                      rd=>memData,
                      wrEnable=>memWriteMemory,
                      clk=>clk);
                                                            
process(memtoReg)
begin
    if(memtoReg='1') then
         writeBack<=memData;
    else
         writeBack<=aluRezultat;
    end if;
end process;

PCSrc<=branch and zero;

process(instruction,reset,sw(7 downto 5))
begin
    case sw(7 downto 5) is
    when "000" =>   
        afisare<=instruction;
    when "001" =>
        afisare<=pc;
    when "010" =>
        afisare<=rd1;
    when "011" =>
        afisare<=rd2;
    when "100"=>
        afisare<=extImm;
    when "101"=>
        afisare<=aluRezultat;
    when "110"=>
        afisare<=memData;
    when "111"=>
        afisare<=writeBack; --(pe writeData scriu writeBack,practic)
    when others =>
        afisare<=instruction;
    end case;
end process;              
                                                       
SSD_map:SSD port map(digit0=>afisare(3 downto 0),
                    digit1=>afisare(7 downto 4),
                    digit2=>afisare(11 downto 8),
                    digit3=>afisare(15 downto 12),
                    clk=>clk,
                    an=>an,
                    cat=>cat);         
                    
led(15)<=regDst;
led(14)<=extOp;
led(13)<=ALUSrc;
led(12)<=branch;
led(11)<=jump;
led(10 downto 8)<=ALUOp;
led(7)<=memWrite;
led(6)<=memtoReg;
led(5)<=regWrite;
led(4 downto 0)<="00000";
--an <= btn(3 downto 0);
--cat <= (others=>'0');
end Behavioral;
