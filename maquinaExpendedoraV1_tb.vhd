library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_expendedora is
end tb_expendedora;

architecture Behavioral of tb_expendedora is
    constant clk_periodo : time := 10 ns;
    signal clk, rst : std_logic := '0';
    signal coin_in : std_logic_vector(1 downto 0);
    signal coin_out : std_logic_vector(1 downto 0);
    signal lata : std_logic;
    
    -- Componente a testear
    component m_expendedora is
        port (
            coin_in : in std_logic_vector(1 downto 0);
            rst, clk : in std_logic;
            coin_out : out std_logic_vector(1 downto 0);
            lata : out std_logic
        );
    end component;

begin

    dut: m_expendedora port map (
        coin_in => coin_in,
        rst => rst,
        clk => clk,
        coin_out => coin_out,
        lata => lata
    );

    clk_process: process
    begin
        while now < 200 ns loop
            wait for clk_periodo / 2;
            clk <= not clk;
        end loop;
        wait;
    end process;
    
    test_process: process
    begin
        wait for clk_periodo / 4; -- Espera inicial
        
        -- No ingresas nada
        wait until rising_edge(clk);
        coin_in <= "00";
        
        -- Ingreso de 1$ despues de haber metido 1$
        wait until rising_edge(clk);
        coin_in <= "01";
        
        wait until rising_edge(clk); 
        coin_in <= "01";
        
        -- Ingreso de 2$ despues de haber metido 1$
        wait until rising_edge(clk);
        coin_in <= "01";
        
        wait until rising_edge(clk);
        coin_in <= "10";
        
        -- Ingreso de 5$ despues de haber metido 1$
        wait until rising_edge(clk);
        coin_in <= "01";
        
        wait until rising_edge(clk); 
        coin_in <= "11";
        
        -- No ingreso de moneda despues de haber metido 1$. Ingreso de 1$ tras
        -- comprobar que continúa la operación.
        
        wait until rising_edge(clk);
        coin_in <= "01";
        
        wait until rising_edge(clk); 
        coin_in <= "00";
        
        wait until rising_edge(clk); 
        coin_in <= "01";
        
        -- Pulso de reset despues de haber metido 1$
        
        wait until rising_edge(clk);
        coin_in <= "01";
        wait until rising_edge(clk);
        rst <= '1';
        wait for clk_periodo / 2;
        rst <= '0';
        wait for clk_periodo / 2;
        
        -- Ingresas 2$
        wait until rising_edge(clk);
        coin_in <= "10";
        
        -- Ingresas 5$
        wait until rising_edge(clk); 
        coin_in <= "11";
            
        wait;
    end process;

 end Behavioral;
