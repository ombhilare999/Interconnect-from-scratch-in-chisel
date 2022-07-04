-- #############################################################################
-- axi_pkg.vhd
-- ===========
-- This package contains constants/functions which are useful to all AXI4
-- interfaces.
--
-- Author : Sahand Kashani-Akhavan [sahand.kashani-akhavan@epfl.ch]
-- Revision : 0.6
-- Last updated : 2017-07-21 15:24:01 UTC
-- #############################################################################

library ieee;
use ieee.std_logic_1164.all;

package axi_pkg is

    -- -------------------------------------------------------------------------
    -- AXI4 bus widths ---------------------------------------------------------
    -- -------------------------------------------------------------------------
    -- Burst type
    constant C_AXI_AXBURST_WIDTH  : positive := 2;
    -- Memory type
    constant C_AXI_AXCACHE_WIDTH  : positive := 4;
    -- Burst length
    constant C_AXI_AXLEN_WIDTH    : positive := 8;
    -- Protection type
    constant C_AXI_AXPROT_WIDTH   : positive := 3;
    -- Quality of Service
    constant C_AXI_AXQOS_WIDTH    : positive := 4;
    -- Region identifier
    constant C_AXI_AXREGION_WIDTH : positive := 4;
    -- Burst size
    constant C_AXI_AXSIZE_WIDTH   : positive := 3;
    -- Read/Write response
    constant C_AXI_XRESP_WIDTH    : positive := 2;

    -- -------------------------------------------------------------------------
    -- AXI4 burst types --------------------------------------------------------
    -- -------------------------------------------------------------------------
    constant C_AXI_AXBURST_FIXED    : std_logic_vector(C_AXI_AXBURST_WIDTH - 1 downto 0) := "00";
    constant C_AXI_AXBURST_INCR     : std_logic_vector(C_AXI_AXBURST_WIDTH - 1 downto 0) := "01";
    constant C_AXI_AXBURST_WRAP     : std_logic_vector(C_AXI_AXBURST_WIDTH - 1 downto 0) := "10";
    constant C_AXI_AXBURST_RESERVED : std_logic_vector(C_AXI_AXBURST_WIDTH - 1 downto 0) := "11";

    -- -------------------------------------------------------------------------
    -- AXI4 memory attributes --------------------------------------------------
    -- -------------------------------------------------------------------------
    -- Bit indices
    constant C_AXI_AXCACHE_BUFFERABLE_IDX     : natural   := 0;
    constant C_AXI_AXCACHE_MODIFIABLE_IDX     : natural   := 1;
    constant C_AXI_AXCACHE_READ_ALLOCATE_IDX  : natural   := 2;
    constant C_AXI_AXCACHE_WRITE_ALLOCATE_IDX : natural   := 3;
    -- Flags
    constant C_AXI_AXCACHE_NON_BUFFERABLE     : std_logic := '0';
    constant C_AXI_AXCACHE_BUFFERABLE         : std_logic := '1';
    constant C_AXI_AXCACHE_NON_MODIFIABLE     : std_logic := '0';
    constant C_AXI_AXCACHE_MODIFIABLE         : std_logic := '1';
    constant C_AXI_AXCACHE_NO_READ_ALLOCATE   : std_logic := '0';
    constant C_AXI_AXCACHE_READ_ALLOCATE      : std_logic := '1';
    constant C_AXI_AXCACHE_NO_WRITE_ALLOCATE  : std_logic := '0';
    constant C_AXI_AXCACHE_WRITE_ALLOCATE     : std_logic := '1';

    -- -------------------------------------------------------------------------
    -- AXI4 access permissions -------------------------------------------------
    -- -------------------------------------------------------------------------
    -- Bit indices
    constant C_AXI_AXPROT_PRIVILEGE_IDX       : natural   := 0;
    constant C_AXI_AXPROT_SECURE_IDX          : natural   := 1;
    constant C_AXI_AXPROT_TYPE_IDX            : natural   := 2;
    -- Flags
    constant C_AXI_AXPROT_UNPRIVILEGED_ACCESS : std_logic := '0';
    constant C_AXI_AXPROT_PRIVILEGED_ACCESS   : std_logic := '1';
    constant C_AXI_AXPROT_SECURE_ACCESS       : std_logic := '0';
    constant C_AXI_AXPROT_NON_SECURE_ACCESS   : std_logic := '1';
    constant C_AXI_AXPROT_DATA_ACCESS         : std_logic := '0';
    constant C_AXI_AXPROT_INSTRUCTION_ACCESS  : std_logic := '1';

    -- -------------------------------------------------------------------------
    -- AXI4 burst sizes --------------------------------------------------------
    -- -------------------------------------------------------------------------
    constant C_AXI_AXSIZE_BYTES_1   : std_logic_vector(C_AXI_AXSIZE_WIDTH - 1 downto 0) := "000";
    constant C_AXI_AXSIZE_BYTES_2   : std_logic_vector(C_AXI_AXSIZE_WIDTH - 1 downto 0) := "001";
    constant C_AXI_AXSIZE_BYTES_4   : std_logic_vector(C_AXI_AXSIZE_WIDTH - 1 downto 0) := "010";
    constant C_AXI_AXSIZE_BYTES_8   : std_logic_vector(C_AXI_AXSIZE_WIDTH - 1 downto 0) := "011";
    constant C_AXI_AXSIZE_BYTES_16  : std_logic_vector(C_AXI_AXSIZE_WIDTH - 1 downto 0) := "100";
    constant C_AXI_AXSIZE_BYTES_32  : std_logic_vector(C_AXI_AXSIZE_WIDTH - 1 downto 0) := "101";
    constant C_AXI_AXSIZE_BYTES_64  : std_logic_vector(C_AXI_AXSIZE_WIDTH - 1 downto 0) := "110";
    constant C_AXI_AXSIZE_BYTES_128 : std_logic_vector(C_AXI_AXSIZE_WIDTH - 1 downto 0) := "111";

    -- -------------------------------------------------------------------------
    -- AXI4 response codes -----------------------------------------------------
    -- -------------------------------------------------------------------------
    -- Normal access success
    constant C_AXI_XRESP_OKAY   : std_logic_vector(C_AXI_XRESP_WIDTH - 1 downto 0) := "00";
    -- Exclusive access success
    constant C_AXI_XRESP_EXOKAY : std_logic_vector(C_AXI_XRESP_WIDTH - 1 downto 0) := "01";
    -- Slave error
    constant C_AXI_XRESP_SLVERR : std_logic_vector(C_AXI_XRESP_WIDTH - 1 downto 0) := "10";
    -- Decode error
    constant C_AXI_XRESP_DECERR : std_logic_vector(C_AXI_XRESP_WIDTH - 1 downto 0) := "11";

end package axi_pkg;

package body axi_pkg is

end package body axi_pkg;
