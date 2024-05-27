
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity m_expendedoraV2_tb is
end m_expendedoraV2_tb;

architecture Behavioral of m_expendedoraV2_tb is

component m_expV2 is
    
        port(
            coin_in : in std_logic_vector(1 downto 0);
            rst, clk, reponedor : in std_logic;
            coin_out : out std_logic_vector(2 downto 0);
            lata : out std_logic
        );

    end component;
    
constant clk_periodo : time := 10 ns;
signal coin_in : std_logic_vector(1 downto 0);
signal rst, clk, reponedor : std_logic := '0';
signal coin_out : std_logic_vector(2 downto 0);
signal lata: std_logic;
    
begin

    dut : m_expV2 port map(coin_in, rst, clk, reponedor, coin_out, lata);
    
    clk_process: process
    begin
        while now < 1000 ns loop
            wait for clk_periodo / 2;
            clk <= not clk;
        end loop;
        wait;
    end process;
    
    test_process: process
    begin
        wait for clk_periodo / 4; -- Espera inicial para asegurar la estabilización del sistema
        
        wait until rising_edge(clk);
        coin_in <= "00";
        
        wait until rising_edge(clk); -- Lata 1
        coin_in <= "10";
        
        wait until rising_edge(clk); -- Lata 2
        coin_in <= "11";
        
        wait until rising_edge(clk);
        coin_in <= "01";
        
        wait until rising_edge(clk); -- Lata 3
        coin_in <= "11";
        
        wait until rising_edge(clk); -- NO QUEDAN LATAS
        coin_in <= "10";
        
        wait until rising_edge(clk); -- Probamos los cambios que devuelve
        coin_in <= "11";
        
        wait until rising_edge(clk); -- Probamos los cambios que devuelve
        coin_in <= "00";
        
        wait until rising_edge(clk); -- REPONEDOR
        reponedor <= '1';
        
        wait until rising_edge(clk); 
        reponedor <= '0';
        
        wait until rising_edge(clk);
        coin_in <= "00";
        
        wait until rising_edge(clk); -- Lata 1 (comprobamos que se ha rellenado la máquina)
        coin_in <= "10";
        
        wait until rising_edge(clk); -- Lata 2
        coin_in <= "10";
        
         wait until rising_edge(clk); -- Lata 3
        coin_in <= "10";
        
        -- NO QUEDAN LATAS
            
        wait;
    end process;

end Behavioral;
