-- #############################################################################
-- helper_pkg.vhd
-- ==============
-- This package contains data structures, functions & constants which are useful
-- to many RTL designs.
--
-- Author : Sahand Kashani-Akhavan [sahand.kashani-akhavan@epfl.ch]
-- Revision : 0.17
-- Last updated : 2017-08-08 04:10:41 UTC
-- #############################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library swift;
use swift.axi_pkg.all;

package helper_pkg is

    -- -------------------------------------------------------------------------
    -- Data structures (general) -----------------------------------------------
    -- -------------------------------------------------------------------------

    -- In all our designs, we constrain the array as (0 TO xxx'length - 1), NOT
    -- (xxx'length - 1 DOWNTO 0).
    type natural_vector is array(natural range <>) of natural;

    -- Unconstrained array in 2nd dimension. Needs to be constrained before it
    -- can be used in any RTL design or testbench. In all our designs, we use
    -- the FIRST dimension as (0 TO xxx'length - 1), and the SECOND dimension as
    -- (xxx'length - 1 DOWNTO 0).
    -- ATTENTION: requires VHDL-2008.
    type slv_vector is array(natural range <>) of std_logic_vector;

    -- -------------------------------------------------------------------------
    -- General helpers ---------------------------------------------------------
    -- -------------------------------------------------------------------------

    function ceil_log2(constant num : in positive) return natural;

    function width_excl(constant count : in positive) return positive;

    function width_incl(constant count : in positive) return positive;

    function min2(constant a : in natural; constant b : in natural) return natural;

    function min2(constant a : in unsigned; constant b : in unsigned) return unsigned;

    function min3(constant a : in unsigned; constant b : in unsigned; constant c : in unsigned) return unsigned;

    function max2(constant a : in natural; constant b : in natural) return natural;

    function max3(constant a : in natural; constant b : in natural; constant c : natural) return natural;

    function bool_to_sl(constant b : in boolean) return std_logic;

    function byte_cnt(constant width : in positive) return positive;

    function word_cnt(constant num_bytes : in unsigned; constant word_width : in positive) return unsigned;

    function align_addr(constant addr : in std_logic_vector; constant boundary : in positive) return std_logic_vector;

    function align_addr_next(constant addr : in std_logic_vector; constant boundary : in positive) return std_logic_vector;

    function compute_addr_next_4KB_boundary(constant addr : in std_logic_vector) return std_logic_vector;

    function xact_crosses_next_4KB_boundary(constant addr : in std_logic_vector; constant burst_len : in std_logic_vector; constant data_width : in positive) return std_logic;

end package helper_pkg;

package body helper_pkg is

    -- -------------------------------------------------------------------------
    -- General helpers ---------------------------------------------------------
    -- -------------------------------------------------------------------------

    -- Computes the integer result of ceil(log2(num)).
    function ceil_log2(constant num : in positive) return natural is
    begin
        return integer(ceil(log2(real(num))));
    end function ceil_log2;

    -- Computes the number of bits needed to count from 0 to count (exclusive).
    function width_excl(constant count : in positive) return positive is
        variable width : positive;
    begin
        if count = 1 then
            width := 1;
        else
            width := ceil_log2(count);
        end if;
        return width;
    end function width_excl;

    -- Computes the number of bits needed to count from 0 to count (inclusive).
    function width_incl(constant count : in positive) return positive is
        variable width : positive;
    begin
        if count = 1 then
            width := 1;
        else
            width := width_excl(count + 1);
        end if;
        return width;
    end function width_incl;

    -- Returns the minimum of the 2 input values.
    function min2(constant a : in natural; constant b : in natural) return natural is
        variable tmp : natural;
    begin
        if a > b then
            tmp := b;
        else
            tmp := a;
        end if;
        return tmp;
    end function min2;

    -- Returns the minimum of the 2 input values. The result has the same bit
    -- width as the largest of the 2 inputs.
    function min2(constant a : in unsigned; constant b : in unsigned) return unsigned is
        variable tmp : unsigned(max2(a'length, b'length) - 1 downto 0);
    begin
        if a > b then
            tmp := b;
        else
            tmp := a;
        end if;
        return tmp;
    end function min2;

    -- Returns the minimum of the 3 inputs values. The result has the same bit
    -- width as the largest of the 3 inputs.
    function min3(constant a : in unsigned; constant b : in unsigned; constant c : in unsigned) return unsigned is
    begin
        return min2(a, min2(b, c));
    end function min3;

    -- Returns the maximum of the 2 input values.
    function max2(constant a : in natural; constant b : in natural) return natural is
        variable tmp : natural;
    begin
        if a > b then
            tmp := a;
        else
            tmp := b;
        end if;
        return tmp;
    end function max2;

    -- Returns the maximum of the 3 input values.
    function max3(constant a : in natural; constant b : in natural; constant c : in natural) return natural is
    begin
        return max2(a, max2(b, c));
    end function max3;

    function bool_to_sl(constant b : in boolean) return std_logic is
    begin
        if b then
            return '1';
        else
            return '0';
        end if;
    end function bool_to_sl;

    -- Returns the number of bytes in the given bit width. The input bit width
    -- must be a multiple of 8.
    function byte_cnt(constant width : in positive) return positive is
    begin
        return width / 8;
    end function byte_cnt;

    function word_cnt(constant num_bytes  : in unsigned;
                      constant word_width : in positive
    ) return unsigned is
        constant C_ADDR_LSB : natural := ceil_log2(byte_cnt(word_width));
    begin
        return shift_right(num_bytes, C_ADDR_LSB);
    end function word_cnt;

    -- Aligns "addr" to the CURRENT closest "boundary" byte-boundary. If "addr"
    -- is already aligned to "boundary", then "addr" is returned unchanged. If
    -- "addr" is not aligned to "boundary", then it is aligned to the CURRENT
    -- "boundary".
    --
    -- Examples
    -- ========
    -- addr = 0x1000, boundary = 4 => return 0x1000
    -- addr = 0x1001, boundary = 4 => return 0x1000
    -- addr = 0x1002, boundary = 4 => return 0x1000
    -- addr = 0x1003, boundary = 4 => return 0x1000
    -- addr = 0x1004, boundary = 4 => return 0x1004
    function align_addr(constant addr     : in std_logic_vector;
                        constant boundary : in positive
    ) return std_logic_vector is
        constant C_ADDR_LSB : natural := ceil_log2(boundary);
        variable aligned    : std_logic_vector(addr'range);
    begin
        aligned := addr;

        if boundary /= 1 then
            aligned(C_ADDR_LSB - 1 downto 0) := (others => '0');
        end if;

        return aligned;
    end function align_addr;

    -- Aligns "addr" to the NEXT closest "boundary" byte-boundary. If "addr" is
    -- already aligned to "boundary", then "addr" is returned unchanged. If
    -- "addr" is not aligned to "boundary", then it is aligned to the NEXT
    -- "boundary".
    --
    -- Examples
    -- ========
    -- addr = 0x1000, boundary = 4 => return 0x1000
    -- addr = 0x1001, boundary = 4 => return 0x1004
    -- addr = 0x1002, boundary = 4 => return 0x1004
    -- addr = 0x1003, boundary = 4 => return 0x1004
    -- addr = 0x1004, boundary = 4 => return 0x1004
    function align_addr_next(constant addr     : in std_logic_vector;
                             constant boundary : in positive
    ) return std_logic_vector is
        constant C_ADDR : std_logic_vector(addr'range) := std_logic_vector(unsigned(addr) + boundary - 1);
    begin
        return align_addr(C_ADDR, boundary);
    end function align_addr_next;

    -- This function computes the address of the next 4KB boundary given the
    -- current address.
    --
    -- Note that this function expects the width of the current address is large
    -- enough to correctly hold the value of the next 4KB address without
    -- wrapping around.
    function compute_addr_next_4KB_boundary(constant addr : in std_logic_vector) return std_logic_vector is
        variable res : unsigned(addr'range);
    begin
        res(addr'length - 1 downto 12) := unsigned(addr(addr'length - 1 downto 12)) + 1;
        res(11 downto 0)               := (others => '0');
        return std_logic_vector(res);
    end function compute_addr_next_4KB_boundary;

    -- This function computes whether the transaction will cross the next 4KB
    -- address boundary.
    --
    -- The inputs to this function are
    --   1) The current address
    --   2) The desired burst length (starts from 1). Expected values are
    --      between [1 .. 256].
    --   3) The word width (width of the data bus)
    --
    -- Note that this function expects the width of the current address is large
    -- enough to correctly hold the value of the next 4KB address without
    -- wrapping around.
    function xact_crosses_next_4KB_boundary(constant addr       : in std_logic_vector;
                                            constant burst_len  : in std_logic_vector;
                                            constant data_width : in positive
    ) return std_logic is
        constant C_ADDR_LSB : natural := ceil_log2(byte_cnt(data_width));

        variable addr_next_4KB_boundary             : unsigned(addr'range);
        variable num_bytes_to_next_4KB_boundary     : unsigned(addr'range);
        variable num_transfers_to_next_4KB_boundary : unsigned(addr'range);

        variable res : unsigned(addr'range);
    begin
        addr_next_4KB_boundary             := unsigned(compute_addr_next_4KB_boundary(addr));
        num_bytes_to_next_4KB_boundary     := addr_next_4KB_boundary - unsigned(addr);
        num_transfers_to_next_4KB_boundary := shift_right(num_bytes_to_next_4KB_boundary, C_ADDR_LSB);

        return bool_to_sl(num_transfers_to_next_4KB_boundary < unsigned(burst_len));
    end function xact_crosses_next_4KB_boundary;

end package body helper_pkg;
