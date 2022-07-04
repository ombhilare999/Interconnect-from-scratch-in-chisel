-- #############################################################################
-- memory_top.vhd
-- ==============
-- Simple AXI4-Full memory slave.
--
-- This design should only be used in testbenches (not in RTL designs). If
-- synthesized, this design would only use on-chip memory and would quickly
-- deplete available on-chip memory resources, even for relatively small memory
-- sizes.
--
-- This design was heavily edited from a Xilinx-generated template. Note that
-- although the AXI4 bus supports full-duplex data transfers through the AXI4
-- protocol's separate write and read channels, the original design generated by
-- Xilinx's toolchain does NOT support this feature (even if different word
-- lanes are being accessed). To get around this issue, we patched the original
-- design to add support for full-duplex data transfers. Note though that
-- simultaneous reads & writes to the same word lane results in undefined
-- behavior!
--
-- Additionally, the behavior of the original template is incorrect with respect
-- to the semantics of the AXI specification because it did not reflect the
-- appropriate BID or RID received from a master, but rather just wired AWID to
-- BID and ARID to RID. First, this violates the specification as it states that
-- there can be no combinatorial paths from AXI inputs to AXI outputs. Second,
-- such a design does not have a valid response in BID and RID in such a case as
-- the master could have already de-asserted its AWID and ARID outputs,
-- therefore causing the obtained response ID to vary within a single
-- transaction non-deterministically. To fix these issues, we patched the
-- implementation to add registers that hold AWID and ARID and appropriately
-- relfect their values when the time comes as response identifiers on BID and
-- RID.
--
-- Author : Sahand Kashani-Akhavan [sahand.kashani-akhavan@epfl.ch]
-- Revision : 0.11
-- Last updated : 2017-11-10 08:39:48 UTC
-- #############################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library swift;
use swift.axi_pkg.all;
use swift.helper_pkg.all;

entity memory_top is
    generic(
        -- Width of address bus
        G_ADDR_WIDTH : positive;

        -- Width of data bus
        G_DATA_WIDTH : positive;

        -- Width of ID for for write address, write response, read address and read data
        G_ID_WIDTH : positive
    );
    port(
        -- ---------------------------------------------------------------------
        -- Global signals ------------------------------------------------------
        -- ---------------------------------------------------------------------
        ACLK    : in std_logic;
        ARESETn : in std_logic;

        -- ---------------------------------------------------------------------
        -- Slave data interface (AXI4) -----------------------------------------
        -- ---------------------------------------------------------------------
        S_AXI_AWADDR  : in  std_logic_vector(G_ADDR_WIDTH - 1 downto 0);
        S_AXI_AWBURST : in  std_logic_vector(C_AXI_AXBURST_WIDTH - 1 downto 0);
        S_AXI_AWID    : in  std_logic_vector(G_ID_WIDTH - 1 downto 0);
        S_AXI_AWLEN   : in  std_logic_vector(C_AXI_AXLEN_WIDTH - 1 downto 0);
        S_AXI_AWPROT  : in  std_logic_vector(C_AXI_AXPROT_WIDTH - 1 downto 0);
        S_AXI_AWREADY : out std_logic;
        S_AXI_AWSIZE  : in  std_logic_vector(C_AXI_AXSIZE_WIDTH - 1 downto 0);
        S_AXI_AWVALID : in  std_logic;
        S_AXI_WDATA   : in  std_logic_vector(G_DATA_WIDTH - 1 downto 0);
        S_AXI_WLAST   : in  std_logic;
        S_AXI_WREADY  : out std_logic;
        S_AXI_WSTRB   : in  std_logic_vector(byte_cnt(G_DATA_WIDTH) - 1 downto 0);
        S_AXI_WVALID  : in  std_logic;
        S_AXI_BID     : out std_logic_vector(G_ID_WIDTH - 1 downto 0);
        S_AXI_BREADY  : in  std_logic;
        S_AXI_BRESP   : out std_logic_vector(C_AXI_XRESP_WIDTH - 1 downto 0);
        S_AXI_BVALID  : out std_logic;
        S_AXI_ARADDR  : in  std_logic_vector(G_ADDR_WIDTH - 1 downto 0);
        S_AXI_ARBURST : in  std_logic_vector(C_AXI_AXBURST_WIDTH - 1 downto 0);
        S_AXI_ARID    : in  std_logic_vector(G_ID_WIDTH - 1 downto 0);
        S_AXI_ARLEN   : in  std_logic_vector(C_AXI_AXLEN_WIDTH - 1 downto 0);
        S_AXI_ARPROT  : in  std_logic_vector(C_AXI_AXPROT_WIDTH - 1 downto 0);
        S_AXI_ARREADY : out std_logic;
        S_AXI_ARSIZE  : in  std_logic_vector(C_AXI_AXSIZE_WIDTH - 1 downto 0);
        S_AXI_ARVALID : in  std_logic;
        S_AXI_RDATA   : out std_logic_vector(G_DATA_WIDTH - 1 downto 0);
        S_AXI_RID     : out std_logic_vector(G_ID_WIDTH - 1 downto 0);
        S_AXI_RLAST   : out std_logic;
        S_AXI_RREADY  : in  std_logic;
        S_AXI_RRESP   : out std_logic_vector(C_AXI_XRESP_WIDTH - 1 downto 0);
        S_AXI_RVALID  : out std_logic
    );
end entity memory_top;

architecture rtl of memory_top is
    ----------------------------------------------------------------------------
    -- AXI4-Full registers -----------------------------------------------------
    ----------------------------------------------------------------------------
    signal reg_axi_awaddr     : unsigned(S_AXI_AWADDR'range);
    signal reg_axi_awburst    : std_logic_vector(S_AXI_AWBURST'range);
    signal reg_axi_awid       : std_logic_vector(S_AXI_AWID'range);
    signal reg_axi_awlen      : unsigned(S_AXI_AWLEN'range);
    -- The reg_axi_awlen_cntr internal write address counter to keep track of
    -- beats in a burst transaction.
    signal reg_axi_awlen_cntr : unsigned(S_AXI_AWLEN'range);
    signal reg_axi_awready    : std_logic;
    -- The reg_axi_awvalid flag marks the presence of write address valid.
    signal reg_axi_awvalid    : std_logic;
    signal reg_axi_wready     : std_logic;
    signal reg_axi_bid        : std_logic_vector(S_AXI_BID'range);
    signal reg_axi_bresp      : std_logic_vector(S_AXI_BRESP'range);
    signal reg_axi_bvalid     : std_logic;
    signal reg_axi_araddr     : unsigned(S_AXI_ARADDR'range);
    signal reg_axi_arburst    : std_logic_vector(S_AXI_ARBURST'range);
    signal reg_axi_arid       : std_logic_vector(S_AXI_ARID'range);
    signal reg_axi_arlen      : unsigned(S_AXI_ARLEN'range);
    -- The reg_axi_arlen_cntr internal read address counter to keep track of
    -- beats in a burst transaction.
    signal reg_axi_arlen_cntr : unsigned(S_AXI_ARLEN'range);
    signal reg_axi_arready    : std_logic;
    -- The reg_axi_arvalid flag marks the presence of read address valid.
    signal reg_axi_arvalid    : std_logic;
    signal reg_axi_rid        : std_logic_vector(S_AXI_RID'range);
    signal reg_axi_rlast      : std_logic;
    signal reg_axi_rresp      : std_logic_vector(S_AXI_RRESP'range);
    signal reg_axi_rvalid     : std_logic;

    ----------------------------------------------------------------------------
    -- AXI4-Full signals -------------------------------------------------------
    ----------------------------------------------------------------------------
    -- axi_aw_wrap_en determines wrap boundary and enables wrapping.
    signal axi_aw_wrap_en   : std_logic;
    -- axi_ar_wrap_en determines wrap boundary and enables wrapping.
    signal axi_ar_wrap_en   : std_logic;
    -- axi_aw_wrap_size is the size of the write transfer, the write address
    -- wraps to a lower address if upper address limit is reached.
    signal axi_aw_wrap_size : natural;
    -- axi_ar_wrap_size is the size of the read transfer, the read address wraps
    -- to a lower address if upper address limit is reached.
    signal axi_ar_wrap_size : natural;
    signal axi_rdata        : std_logic_vector(S_AXI_RDATA'range);

    -- local parameter for addressing 32, 64, ... bit S_AXI_WDATA or
    -- S_AXI_RDATA.
    -- C_ADDR_LSB is used for addressing 32,64, ... bit registers/memories
    -- C_ADDR_LSB = 2 for 32  bits (n downto 2)
    -- C_ADDR_LSB = 3 for 64  bits (n downto 3)
    -- C_ADDR_LSB = 4 for 128 bits (n downto 4)
    -- C_ADDR_LSB = 5 for 256 bits (n downto 5)
    constant C_ADDR_LSB : natural := ceil_log2(byte_cnt(G_DATA_WIDTH));

    ----------------------------------------------------------------------------
    -- Memory signals ----------------------------------------------------------
    ----------------------------------------------------------------------------
    -- From the outside, the memory looks like a single large byte-addressable
    -- memory of size (2 ** G_ADDR_WIDTH) bytes.
    --
    --                          8
    --                      <------->
    --                     +---------+
    --                   ^ |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    -- 2 ** G_ADDR_WIDTH | |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    --                   | |         |
    --                   v |         |
    --                     +---------+
    --
    -- However, the representation above is not used internally. It is instead
    -- represented as multiple smaller byte-addressable memories each of size
    -- (2 ** G_ADDR_WIDTH) / (2 ** byte_cnt(G_DATA_WIDTH)).
    --
    --                                      8           8               8
    --                                  <------->   <------->       <------->
    --                                 +---------+ +---------+     +---------+
    --                               ^ |         | |         |     |         |
    --      (2 ** G_ADDR_WIDTH)      | |         | |         |     |         |
    -- ----------------------------- | |         | |         | ... |         |
    -- (2 ** byte_cnt(G_DATA_WIDTH)) | |         | |         |     |         |
    --                               v |         | |         |     |         |
    --                                 +---------+ +---------+     +---------+
    --
    -- This internal organization is adopted so we can support reads and writes
    -- as wide as the width of the S_AXI_RDATA / S_AXI_WDATA busses.

    -- Width of the address bus for the smaller internal memories.
    constant C_MEM_ADDR_BITS : natural := G_ADDR_WIDTH - C_ADDR_LSB;

    -- Small internal memory type.
    type byte_ram_type is array(0 to (2 ** C_MEM_ADDR_BITS) - 1) of std_logic_vector(7 downto 0);

    -- Address issued to all small internal memories (same address for all).
    signal mem_wraddr : unsigned(C_MEM_ADDR_BITS - 1 downto 0);
    signal mem_rdaddr : unsigned(C_MEM_ADDR_BITS - 1 downto 0);

    -- Combined output (same size as S_AXI_RDATA) of data read from all
    -- small internal memories and to be outputted on AXI interface.
    signal mem_data_out : std_logic_vector(S_AXI_RDATA'range);

begin

    -- Implement axi_ax_wrap_en generation
    -- ===================================
    process(axi_ar_wrap_size, axi_aw_wrap_size, reg_axi_araddr, reg_axi_awaddr)
        variable aw_wrap_size_unsigned : unsigned(reg_axi_awaddr'range);
        variable ar_wrap_size_unsigned : unsigned(reg_axi_araddr'range);
    begin
        aw_wrap_size_unsigned := to_unsigned(axi_aw_wrap_size, reg_axi_awaddr'length);
        ar_wrap_size_unsigned := to_unsigned(axi_ar_wrap_size, reg_axi_araddr'length);

        if ((reg_axi_awaddr and aw_wrap_size_unsigned) xor aw_wrap_size_unsigned) = 0 then
            axi_aw_wrap_en <= '1';
        else
            axi_aw_wrap_en <= '0';
        end if;

        if ((reg_axi_araddr and ar_wrap_size_unsigned) xor ar_wrap_size_unsigned) = 0 then
            axi_ar_wrap_en <= '1';
        else
            axi_ar_wrap_en <= '0';
        end if;
    end process;

    -- Implement axi_ax_wrap_size generation
    -- =====================================
    process(reg_axi_arlen, reg_axi_awlen)
    begin
        axi_aw_wrap_size <= byte_cnt(S_AXI_WDATA'length) * to_integer(reg_axi_awlen);
        axi_ar_wrap_size <= byte_cnt(S_AXI_RDATA'length) * to_integer(reg_axi_arlen);
    end process;

    -- Implement reg_axi_awready generation
    -- ====================================
    -- reg_axi_awready is asserted for one ACLK clock cycle when both
    -- S_AXI_AWVALID and S_AXI_WVALID are asserted. reg_axi_awready is de-
    -- asserted when reset is low.
    process(ACLK)
    begin
        if rising_edge(ACLK) then
            if ARESETn = '0' then
                reg_axi_awready <= '0';
                reg_axi_awvalid <= '0';
            else
                if reg_axi_awready = '0' and S_AXI_AWVALID = '1' and reg_axi_awvalid = '0' and reg_axi_arvalid = '0' then
                    -- slave is ready to accept an address and associated
                    -- control signals

                    -- used for generation of bresp and bvalid
                    reg_axi_awvalid <= '1';
                    reg_axi_awready <= '1';
                elsif S_AXI_WLAST = '1' and reg_axi_wready = '1' then
                    -- preparing to accept next address after current write
                    -- burst tx completion
                    reg_axi_awvalid <= '0';
                else
                    reg_axi_awready <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Implement reg_axi_awaddr latching
    -- =================================
    -- This process is used to latch the address when both S_AXI_AWVALID and
    -- S_AXI_WVALID are valid.
    process(ACLK)
    begin
        if rising_edge(ACLK) then
            if ARESETn = '0' then
                reg_axi_awaddr     <= (others => '0');
                reg_axi_awburst    <= (others => '0');
                reg_axi_awid       <= (others => '0');
                reg_axi_awlen      <= (others => '0');
                reg_axi_awlen_cntr <= (others => '0');
            else
                if reg_axi_awready = '0' and S_AXI_AWVALID = '1' and reg_axi_awvalid = '0' then
                    -- address latching
                    reg_axi_awaddr     <= unsigned(S_AXI_AWADDR);
                    reg_axi_awburst    <= S_AXI_AWBURST;
                    reg_axi_awid       <= S_AXI_AWID;
                    reg_axi_awlen      <= unsigned(S_AXI_AWLEN);
                    reg_axi_awlen_cntr <= (others => '0');
                elsif reg_axi_awlen_cntr <= reg_axi_awlen and reg_axi_wready = '1' and S_AXI_WVALID = '1' then
                    reg_axi_awlen_cntr <= reg_axi_awlen_cntr + 1;

                    case reg_axi_awburst is
                        when C_AXI_AXBURST_FIXED =>
                            -- The write address for all the beats in the
                            -- transaction are fixed.
                            reg_axi_awaddr <= reg_axi_awaddr;

                        when C_AXI_AXBURST_INCR =>
                            -- The write address for all the beats in the
                            -- transaction are increments by awsize.
                            reg_axi_awaddr(reg_axi_awaddr'length - 1 downto C_ADDR_LSB) <= reg_axi_awaddr(reg_axi_awaddr'length - 1 downto C_ADDR_LSB) + 1;
                            reg_axi_awaddr(C_ADDR_LSB - 1 downto 0)                     <= (others => '0');

                        when C_AXI_AXBURST_WRAP =>
                            -- The write address wraps when the address reaches
                            -- wrap boundary
                            if axi_aw_wrap_en = '1' then
                                reg_axi_awaddr <= reg_axi_awaddr - to_unsigned(axi_aw_wrap_size, reg_axi_awaddr'length);
                            else
                                reg_axi_awaddr(reg_axi_awaddr'length - 1 downto C_ADDR_LSB) <= reg_axi_awaddr(reg_axi_awaddr'length - 1 downto C_ADDR_LSB) + 1;
                                reg_axi_awaddr(C_ADDR_LSB - 1 downto 0)                     <= (others => '0');
                            end if;

                        -- C_AXI_AXBURST_RESERVED
                        when others =>
                            -- We decide to do an incremental burst: The write
                            -- address for all the beats in the transaction are
                            -- increments by awsize.
                            reg_axi_awaddr(reg_axi_awaddr'length - 1 downto C_ADDR_LSB) <= reg_axi_awaddr(reg_axi_awaddr'length - 1 downto C_ADDR_LSB) + 1;
                            reg_axi_awaddr(C_ADDR_LSB - 1 downto 0)                     <= (others => '0');
                    end case;
                end if;
            end if;
        end if;
    end process;

    -- Implement reg_axi_wready generation
    -- ===================================
    -- reg_axi_wready is asserted for one ACLK clock cycle when both
    -- S_AXI_AWVALID and S_AXI_WVALID are asserted. reg_axi_wready is de-
    -- asserted when reset is low.
    process(ACLK)
    begin
        if rising_edge(ACLK) then
            if ARESETn = '0' then
                reg_axi_wready <= '0';
            else
                if reg_axi_wready = '0' and S_AXI_WVALID = '1' and reg_axi_awvalid = '1' then
                    reg_axi_wready <= '1';
                elsif S_AXI_WLAST = '1' and reg_axi_wready = '1' then
                    reg_axi_wready <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Implement write response logic generation
    -- =========================================
    -- The write response and response valid signals are asserted by the slave
    -- when reg_axi_wready, S_AXI_WVALID are asserted. This marks the acceptance
    -- of the address and indicates the status of write transaction.
    process(ACLK)
    begin
        if rising_edge(ACLK) then
            if ARESETn = '0' then
                reg_axi_bid    <= (others => '0');
                reg_axi_bvalid <= '0';
                reg_axi_bresp  <= C_AXI_XRESP_OKAY;
            else
                if reg_axi_awvalid = '1' and reg_axi_wready = '1' and S_AXI_WVALID = '1' and reg_axi_bvalid = '0' and S_AXI_WLAST = '1' then
                    reg_axi_bid    <= reg_axi_awid;
                    reg_axi_bvalid <= '1';
                    reg_axi_bresp  <= C_AXI_XRESP_OKAY;
                elsif S_AXI_BREADY = '1' and reg_axi_bvalid = '1' then
                    -- check if bready is asserted while bvalid is high (there
                    -- is a possibility that bready is always asserted high)
                    reg_axi_bvalid <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Implement reg_axi_arready generation
    -- ====================================
    -- reg_axi_arready is asserted for one ACLK clock cycle when
    -- S_AXI_ARVALID is asserted. reg_axi_arready is de-asserted when reset
    -- (active low) is asserted. The read address is also latched when
    -- S_AXI_ARVALID is asserted. reg_axi_araddr is reset to zero on reset
    -- assertion.
    process(ACLK)
    begin
        if rising_edge(ACLK) then
            if ARESETn = '0' then
                reg_axi_arready <= '0';
                reg_axi_arvalid <= '0';
            else
                if reg_axi_arready = '0' and S_AXI_ARVALID = '1' and reg_axi_awvalid = '0' and reg_axi_arvalid = '0' then
                    reg_axi_arready <= '1';
                    reg_axi_arvalid <= '1';
                elsif reg_axi_rvalid = '1' and S_AXI_RREADY = '1' and reg_axi_arlen_cntr = reg_axi_arlen then
                    -- preparing to accept next address after current read
                    -- completion
                    reg_axi_arvalid <= '0';
                else
                    reg_axi_arready <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Implement reg_axi_araddr latching
    -- =================================
    -- This process is used to latch the address when both S_AXI_ARVALID and
    -- S_AXI_RVALID are valid.
    process(ACLK)
    begin
        if rising_edge(ACLK) then
            if ARESETn = '0' then
                reg_axi_araddr     <= (others => '0');
                reg_axi_arburst    <= (others => '0');
                reg_axi_arid       <= (others => '0');
                reg_axi_arlen      <= (others => '0');
                reg_axi_arlen_cntr <= (others => '0');
                reg_axi_rlast      <= '0';
            else
                if reg_axi_arready = '0' and S_AXI_ARVALID = '1' and reg_axi_arvalid = '0' then
                    -- address latching
                    reg_axi_araddr     <= unsigned(S_AXI_ARADDR);
                    reg_axi_arburst    <= S_AXI_ARBURST;
                    reg_axi_arid       <= S_AXI_ARID;
                    reg_axi_arlen      <= unsigned(S_AXI_ARLEN);
                    reg_axi_arlen_cntr <= (others => '0');
                    reg_axi_rlast      <= '0';
                elsif reg_axi_arlen_cntr <= reg_axi_arlen and reg_axi_rvalid = '1' and S_AXI_RREADY = '1' then
                    reg_axi_arlen_cntr <= reg_axi_arlen_cntr + 1;
                    reg_axi_rlast      <= '0';

                    case reg_axi_arburst is
                        when C_AXI_AXBURST_FIXED =>
                            -- The read address for all the beats in the
                            -- transaction are fixed.
                            reg_axi_araddr <= reg_axi_araddr;

                        when C_AXI_AXBURST_INCR =>
                            -- The read address for all the beats in the
                            -- transaction are increments by arsize.
                            reg_axi_araddr(reg_axi_araddr'length - 1 downto C_ADDR_LSB) <= reg_axi_araddr(reg_axi_araddr'length - 1 downto C_ADDR_LSB) + 1;
                            reg_axi_araddr(C_ADDR_LSB - 1 downto 0)                     <= (others => '0');

                        when C_AXI_AXBURST_WRAP =>
                            -- The read address wraps when the address reaches
                            -- wrap boundary.
                            if axi_ar_wrap_en = '1' then
                                reg_axi_araddr <= reg_axi_araddr - to_unsigned(axi_ar_wrap_size, reg_axi_araddr'length);
                            else
                                reg_axi_araddr(reg_axi_araddr'length - 1 downto C_ADDR_LSB) <= reg_axi_araddr(reg_axi_araddr'length - 1 downto C_ADDR_LSB) + 1;
                                reg_axi_araddr(C_ADDR_LSB - 1 downto 0)                     <= (others => '0');
                            end if;

                        -- C_AXI_AXBURST_RESERVED
                        when others =>
                            -- We decide to do an incremental burst: The read
                            -- address for all the beats in the transaction are
                            -- increments by arsize.
                            reg_axi_araddr(reg_axi_araddr'length - 1 downto C_ADDR_LSB) <= reg_axi_araddr(reg_axi_araddr'length - 1 downto C_ADDR_LSB) + 1;
                            reg_axi_araddr(C_ADDR_LSB - 1 downto 0)                     <= (others => '0');
                    end case;

                elsif reg_axi_arlen_cntr = reg_axi_arlen and reg_axi_rlast = '0' and reg_axi_arvalid = '1' then
                    reg_axi_rlast <= '1';

                elsif S_AXI_RREADY = '1' then
                    reg_axi_rlast <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Implement reg_axi_rvalid generation
    -- ===================================
    -- reg_axi_rvalid is asserted for one ACLK clock cycle when both
    -- S_AXI_ARVALID and reg_axi_arready are asserted. The slave registers
    -- data are available on the axi_rdata bus at this instance. The assertion
    -- of reg_axi_rvalid marks the validity of read data on the bus and
    -- reg_axi_rresp indicates the status of read transaction. reg_axi_rvalid is
    -- deasserted on reset (active low). reg_axi_rresp is cleared to zero on
    -- reset (active low).
    process(ACLK)
    begin
        if rising_edge(ACLK) then
            if ARESETn = '0' then
                reg_axi_rid    <= (others => '0');
                reg_axi_rvalid <= '0';
                reg_axi_rresp  <= C_AXI_XRESP_OKAY;
            else
                if reg_axi_arvalid = '1' and reg_axi_rvalid = '0' then
                    reg_axi_rid    <= reg_axi_arid;
                    reg_axi_rvalid <= '1';
                    reg_axi_rresp  <= C_AXI_XRESP_OKAY;
                elsif reg_axi_rvalid = '1' and S_AXI_RREADY = '1' then
                    reg_axi_rvalid <= '0';
                end if;
            end if;
        end if;
    end process;

    ----------------------------------------------------------------------------
    -- Memory access -----------------------------------------------------------
    ----------------------------------------------------------------------------

    process(reg_axi_araddr, reg_axi_arvalid)
    begin
        if reg_axi_arvalid = '1' then
            mem_rdaddr <= reg_axi_araddr(C_MEM_ADDR_BITS + C_ADDR_LSB - 1 downto C_ADDR_LSB);
        else
            mem_rdaddr <= (others => '0');
        end if;
    end process;

    process(reg_axi_awaddr, reg_axi_awvalid)
    begin
        if reg_axi_awvalid = '1' then
            mem_wraddr <= reg_axi_awaddr(C_MEM_ADDR_BITS + C_ADDR_LSB - 1 downto C_ADDR_LSB);
        else
            mem_wraddr <= (others => '0');
        end if;
    end process;

    byte_ram_gen : for mem_byte_idx in 0 to byte_cnt(G_DATA_WIDTH) - 1 generate
        signal byte_ram : byte_ram_type;
        signal rden     : std_logic;
        signal wren     : std_logic;
        signal data_in  : std_logic_vector(7 downto 0);
        signal data_out : std_logic_vector(7 downto 0);
    begin
        wren <= reg_axi_wready and S_AXI_WVALID;
        rden <= reg_axi_arvalid;

        -- Assigning 8-bit data.
        data_in <= S_AXI_WDATA((mem_byte_idx * 8) + 7 downto mem_byte_idx * 8);

        process(ACLK) is
        begin
            if rising_edge(ACLK) then
                if wren = '1' and S_AXI_WSTRB(mem_byte_idx) = '1' then
                    byte_ram(to_integer(mem_wraddr)) <= data_in;
                end if;
            end if;
        end process;

        -- Assigning 8-bit data.
        data_out <= byte_ram(to_integer(mem_rdaddr));

        process(ACLK) is
        begin
            if rising_edge(ACLK) then
                if rden = '1' then
                    mem_data_out((mem_byte_idx * 8) + 7 downto mem_byte_idx * 8) <= data_out;
                end if;
            end if;
        end process;
    end generate byte_ram_gen;

    -- Output register or memory read data
    -- ===================================
    process(mem_data_out, reg_axi_rvalid) is
    begin
        if reg_axi_rvalid = '1' then
            -- When there is a valid read address (S_AXI_ARVALID) with
            -- acceptance of read address by the slave (reg_axi_arready), output
            -- the read data.
            axi_rdata <= mem_data_out;
        else
            axi_rdata <= (others => '0');
        end if;
    end process;

    -- -------------------------------------------------------------------------
    -- Top-level outputs -------------------------------------------------------
    -- -------------------------------------------------------------------------
    S_AXI_AWREADY <= reg_axi_awready;
    S_AXI_WREADY  <= reg_axi_wready;
    S_AXI_BRESP   <= reg_axi_bresp;
    S_AXI_BVALID  <= reg_axi_bvalid;
    S_AXI_ARREADY <= reg_axi_arready;
    S_AXI_RDATA   <= axi_rdata;
    S_AXI_RRESP   <= reg_axi_rresp;
    S_AXI_RLAST   <= reg_axi_rlast;
    S_AXI_RVALID  <= reg_axi_rvalid;
    S_AXI_BID     <= reg_axi_bid;
    S_AXI_RID     <= reg_axi_rid;

end rtl;
