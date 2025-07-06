#!/bin/bash

# ------------------------------------------------------------------------------
# HEADER
# ------------------------------------------------------------------------------
#
# code128.sh
#
# Copyright 2021 Anemisus
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# ------------------------------------------------------------------------------
#
# History:
#     2021/01/05 : anemisus : script creation
#     2021/01/06 : anemisus : added human readable description
#     2021/01/07 : anemisus : added options parsing and new script header
#     2021/01/08 : anemisus : added codeset c and x option
#     2021/01/09 : anemisus : added codeset mapping table and updated help
#     2021/01/10 : anemisus : updated help again
#     2021/01/15 : anemisus : renamed functions and variables
#     2021/10/27 : anemisus : fixed human readable description for codeset c
#
# ------------------------------------------------------------------------------
# END_OF_HEADER
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# VARIABLES
# ------------------------------------------------------------------------------

# basic information
s_program_name=$(basename -- "${0}")
s_program_version="21w43a"

# constants
array_codeset_b=("\u0020" "\u0021" "\u0022" "\u0023" "\u0024" "\u0025" "\u0026"
    "\u0027" "\u0028" "\u0029" "\u002a" "\u002b" "\u002c" "\u002d" "\u002e"
    "\u002f" "\u0030" "\u0031" "\u0032" "\u0033" "\u0034" "\u0035" "\u0036"
    "\u0037" "\u0038" "\u0039" "\u003a" "\u003b" "\u003c" "\u003d" "\u003e"
    "\u003f" "\u0040" "\u0041" "\u0042" "\u0043" "\u0044" "\u0045" "\u0046"
    "\u0047" "\u0048" "\u0049" "\u004a" "\u004b" "\u004c" "\u004d" "\u004e"
    "\u004f" "\u0050" "\u0051" "\u0052" "\u0053" "\u0054" "\u0055" "\u0056"
    "\u0057" "\u0058" "\u0059" "\u005a" "\u005b" "\u005c" "\u005d" "\u005e"
    "\u005f" "\u0060" "\u0061" "\u0062" "\u0063" "\u0064" "\u0065" "\u0066"
    "\u0067" "\u0068" "\u0069" "\u006a" "\u006b" "\u006c" "\u006d" "\u006e"
    "\u006f" "\u0070" "\u0071" "\u0072" "\u0073" "\u0074" "\u0075" "\u0076"
    "\u0077" "\u0078" "\u0079" "\u007a" "\u007b" "\u007c" "\u007d" "\u007e")
    # as complete as possible
array_codeset_c=("\u0030\u0030" "\u0030\u0031" "\u0030\u0032" "\u0030\u0033"
    "\u0030\u0034" "\u0030\u0035" "\u0030\u0036" "\u0030\u0037" "\u0030\u0038"
    "\u0030\u0039" "\u0031\u0030" "\u0031\u0031" "\u0031\u0032" "\u0031\u0033"
    "\u0031\u0034" "\u0031\u0035" "\u0031\u0036" "\u0031\u0037" "\u0031\u0038"
    "\u0031\u0039" "\u0032\u0030" "\u0032\u0031" "\u0032\u0032" "\u0032\u0033"
    "\u0032\u0034" "\u0032\u0035" "\u0032\u0036" "\u0032\u0037" "\u0032\u0038"
    "\u0032\u0039" "\u0033\u0030" "\u0033\u0031" "\u0033\u0032" "\u0033\u0033"
    "\u0033\u0034" "\u0033\u0035" "\u0033\u0036" "\u0033\u0037" "\u0033\u0038"
    "\u0033\u0039" "\u0034\u0030" "\u0034\u0031" "\u0034\u0032" "\u0034\u0033"
    "\u0034\u0034" "\u0034\u0035" "\u0034\u0036" "\u0034\u0037" "\u0034\u0038"
    "\u0034\u0039" "\u0035\u0030" "\u0035\u0031" "\u0035\u0032" "\u0035\u0033"
    "\u0035\u0034" "\u0035\u0035" "\u0035\u0036" "\u0035\u0037" "\u0035\u0038"
    "\u0035\u0039" "\u0036\u0030" "\u0036\u0031" "\u0036\u0032" "\u0036\u0033"
    "\u0036\u0034" "\u0036\u0035" "\u0036\u0036" "\u0036\u0037" "\u0036\u0038"
    "\u0036\u0039" "\u0037\u0030" "\u0037\u0031" "\u0037\u0032" "\u0037\u0033"
    "\u0037\u0034" "\u0037\u0035" "\u0037\u0036" "\u0037\u0037" "\u0037\u0038"
    "\u0037\u0039" "\u0038\u0030" "\u0038\u0031" "\u0038\u0032" "\u0038\u0033"
    "\u0038\u0034" "\u0038\u0035" "\u0038\u0036" "\u0038\u0037" "\u0038\u0038"
    "\u0038\u0039" "\u0039\u0030" "\u0039\u0031" "\u0039\u0032" "\u0039\u0033"
    "\u0039\u0034" "\u0039\u0035" "\u0039\u0036" "\u0039\u0037" "\u0039\u0038"
    "\u0039\u0039") # as complete as possible
array_digits=("\u0030" "\u0031" "\u0032" "\u0033" "\u0034" "\u0035" "\u0036"
    "\u0037" "\u0038" "\u0039") # just to check for single digits
array_patterns=("11011001100" "11001101100" "11001100110" "10010011000"
    "10010001100" "10001001100" "10011001000" "10011000100" "10001100100"
    "11001001000" "11001000100" "11000100100" "10110011100" "10011011100"
    "10011001110" "10111001100" "10011101100" "10011100110" "11001110010"
    "11001011100" "11001001110" "11011100100" "11001110100" "11101101110"
    "11101001100" "11100101100" "11100100110" "11101100100" "11100110100"
    "11100110010" "11011011000" "11011000110" "11000110110" "10100011000"
    "10001011000" "10001000110" "10110001000" "10001101000" "10001100010"
    "11010001000" "11000101000" "11000100010" "10110111000" "10110001110"
    "10001101110" "10111011000" "10111000110" "10001110110" "11101110110"
    "11010001110" "11000101110" "11011101000" "11011100010" "11011101110"
    "11101011000" "11101000110" "11100010110" "11101101000" "11101100010"
    "11100011010" "11101111010" "11001000010" "11110001010" "10100110000"
    "10100001100" "10010110000" "10010000110" "10000101100" "10000100110"
    "10110010000" "10110000100" "10011010000" "10011000010" "10000110100"
    "10000110010" "11000010010" "11001010000" "11110111010" "11000010100"
    "10001111010" "10100111100" "10010111100" "10010011110" "10111100100"
    "10011110100" "10011110010" "11110100100" "11110010100" "11110010010"
    "11011011110" "11011110110" "11110110110" "10101111000" "10100011110"
    "10001011110" "10111101000" "10111100010" "11110101000" "11110100010"
    "10111011110" "10111101110" "11101011110" "11110101110" "11010000100"
    "11010010000" "11010011100" "11000111010")
    # fully complete
int_code_b=100
int_startcode_b=104
int_startcode_c=105
int_stop=106
s_final_bar="11"
s_quietzone="00000000000"

# global variables
array_escaped=()
array_pairs=()
array_values=()
boolean_1st=true
int_barcode_length=0
int_checksum=0
int_description_length=0
int_last_character=0
s_binaries=""
s_description=""
s_input=""
s_invalid_char=""
s_last_character=""
s_padding_character=""
s_pair=""
s_unicodeblocks=""

# option defaults
boolean_debug=
boolean_description=
boolean_invert=true
int_padding_v=0
int_size=1
s_codeset="b"

# ------------------------------------------------------------------------------
# END_OF_VARIABLES
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# FUNCTIONS
# ------------------------------------------------------------------------------

# Exit script on error.
f_die()
{
    printf '%s\n' "${1}" >&2
    exit 1
} # end of f_die

# Print useful information to assist with usage.
f_print_help()
{
    printf '%s\n' "Usage: ${s_program_name} [-hmv] [-options] \"string\""
    printf '\n'
    printf '%s\n' "Description:"
    printf '%s\n' "    This is a script for printing Code 128 barcodes directly into a shell."
    printf '%s\n' "    It utilizes unicode block elements to assemble and print the image."
    printf '\n'
    printf '%s\n' "Options:"
    printf '%s\n' "    -c [b|c|x], --codeset [b|c|x]         Code 128 codeset, defaults to b."
    printf '\n'
    printf '%s\n' "    Codeset b accepts most letters, digits, punctuation and whitespace."
    printf '%s\n' "    This will suit most use cases."
    printf '\n'
    printf '%s\n' "    Codeset c only accepts pairs of digits ranging from 00 to 99."
    printf '%s\n' "    A remaining single digit will be included as codeset b character."
    printf '\n'
    printf '%s\n' "    Option x accepts index values directly. No codeset lookup is done."
    printf '%s\n' "    Checksum and stopcode still get added automatically. In this way,"
    printf '%s\n' "    different codesets can be mixed and values with special functions"
    printf '%s\n' "    can be used. The numbers have to be separated with a comma."
    printf '\n'
    printf '%s\n' "    -d,         --description             Print an additional human"
    printf '%s\n' "                                          readable description"
    printf '%s\n' "                                          (for codesets b and c only)."
    printf '%s\n' "    -i,         --invert                  Invert colors to cope with"
    printf '%s\n' "                                          light themed terminals."
    printf '%s\n' "    -p [num],   --padding-vertical [num]  Amount of padding, defaults to 0."
    printf '%s\n' "    -s [num],   --size [num]              Amount of lines, defaults to 1."
    printf '%s\n' "                --debug                   Print processing information."
    printf '\n'
    printf '%s\n' "    -h,         --help                    Print this help."
    printf '%s\n' "    -m,         --mapping                 Print codeset mapping."
    printf '%s\n' "    -v,         --version                 Print script version."
    printf '\n'
    printf '%s\n' "Examples:"
    printf '%s\n' "    ${s_program_name} -d -p 3 -s 5 \"Example\""
    printf '%s\n' "    ${s_program_name} -c c -d -p 3 -s 5 \"0123456789\""
    printf '%s\n' "    ${s_program_name} -c x -p 3 -s 5 \"104,96,50,69,86,33,101,77\""
    exit 0
} # end of f_print_help

# Print full table of Code 128 codeset mapping.
f_print_mapping()
{
    printf '%s\n' "Mapping:"
    printf '%s\n' "    -------------------------------------------------------------------------"
    printf '%s\n' "    Index  Hex  Codeset 128A  Codeset 128B  Codeset 128C  Pattern      Widths"
    printf '%s\n' "    -------------------------------------------------------------------------"
    printf '%s\n' "    0      00   space         space         00            11011001100  212222"
    printf '%s\n' "    1      01   !             !             01            11001101100  222122"
    printf '%s\n' "    2      02   \"             \"             02            11001100110  222221"
    printf '%s\n' "    3      03   #             #             03            10010011000  121223"
    printf '%s\n' "    4      04   \$             \$             04            10010001100  121322"
    printf '%s\n' "    5      05   %             %             05            10001001100  131222"
    printf '%s\n' "    6      06   &             &             06            10011001000  122213"
    printf '%s\n' "    7      07   '             '             07            10011000100  122312"
    printf '%s\n' "    8      08   (             (             08            10001100100  132212"
    printf '%s\n' "    9      09   )             )             09            11001001000  221213"
    printf '%s\n' "    10     0a   *             *             10            11001000100  221312"
    printf '%s\n' "    11     0b   +             +             11            11000100100  231212"
    printf '%s\n' "    12     0c   ,             ,             12            10110011100  112232"
    printf '%s\n' "    13     0d   -             -             13            10011011100  122132"
    printf '%s\n' "    14     0e   .             .             14            10011001110  122231"
    printf '%s\n' "    15     0f   /             /             15            10111001100  113222"
    printf '%s\n' "    16     10   0             0             16            10011101100  123122"
    printf '%s\n' "    17     11   1             1             17            10011100110  123221"
    printf '%s\n' "    18     12   2             2             18            11001110010  223211"
    printf '%s\n' "    19     13   3             3             19            11001011100  221132"
    printf '%s\n' "    20     14   4             4             20            11001001110  221231"
    printf '%s\n' "    21     15   5             5             21            11011100100  213212"
    printf '%s\n' "    22     16   6             6             22            11001110100  223112"
    printf '%s\n' "    23     17   7             7             23            11101101110  312131"
    printf '%s\n' "    24     18   8             8             24            11101001100  311222"
    printf '%s\n' "    25     19   9             9             25            11100101100  321122"
    printf '%s\n' "    26     1a   :             :             26            11100100110  321221"
    printf '%s\n' "    27     1b   ;             ;             27            11101100100  312212"
    printf '%s\n' "    28     1c   <             <             28            11100110100  322112"
    printf '%s\n' "    29     1d   =             =             29            11100110010  322211"
    printf '%s\n' "    30     1e   >             >             30            11011011000  212123"
    printf '%s\n' "    31     1f   ?             ?             31            11011000110  212321"
    printf '%s\n' "    32     20   @             @             32            11000110110  232121"
    printf '%s\n' "    33     21   A             A             33            10100011000  111323"
    printf '%s\n' "    34     22   B             B             34            10001011000  131123"
    printf '%s\n' "    35     23   C             C             35            10001000110  131321"
    printf '%s\n' "    36     24   D             D             36            10110001000  112313"
    printf '%s\n' "    37     25   E             E             37            10001101000  132113"
    printf '%s\n' "    38     26   F             F             38            10001100010  132311"
    printf '%s\n' "    39     27   G             G             39            11010001000  211313"
    printf '%s\n' "    40     28   H             H             40            11000101000  231113"
    printf '%s\n' "    41     29   I             I             41            11000100010  231311"
    printf '%s\n' "    42     2a   J             J             42            10110111000  112133"
    printf '%s\n' "    43     2b   K             K             43            10110001110  112331"
    printf '%s\n' "    44     2c   L             L             44            10001101110  132131"
    printf '%s\n' "    45     2d   M             M             45            10111011000  113123"
    printf '%s\n' "    46     2e   N             N             46            10111000110  113321"
    printf '%s\n' "    47     2f   O             O             47            10001110110  133121"
    printf '%s\n' "    48     30   P             P             48            11101110110  313121"
    printf '%s\n' "    49     31   Q             Q             49            11010001110  211331"
    printf '%s\n' "    50     32   R             R             50            11000101110  231131"
    printf '%s\n' "    51     33   S             S             51            11011101000  213113"
    printf '%s\n' "    52     34   T             T             52            11011100010  213311"
    printf '%s\n' "    53     35   U             U             53            11011101110  213131"
    printf '%s\n' "    54     36   V             V             54            11101011000  311123"
    printf '%s\n' "    55     37   W             W             55            11101000110  311321"
    printf '%s\n' "    56     38   X             X             56            11100010110  331121"
    printf '%s\n' "    57     39   Y             Y             57            11101101000  312113"
    printf '%s\n' "    58     3a   Z             Z             58            11101100010  312311"
    printf '%s\n' "    59     3b   [             [             59            11100011010  332111"
    printf '%s\n' "    60     3c   \\             \\             60            11101111010  314111"
    printf '%s\n' "    61     3d   ]             ]             61            11001000010  221411"
    printf '%s\n' "    62     3e   ^             ^             62            11110001010  431111"
    printf '%s\n' "    63     3f   _             _             63            10100110000  111224"
    printf '%s\n' "    64     40   NUL           \`             64            10100001100  111422"
    printf '%s\n' "    65     41   SOH           a             65            10010110000  121124"
    printf '%s\n' "    66     42   STX           b             66            10010000110  121421"
    printf '%s\n' "    67     43   ETX           c             67            10000101100  141122"
    printf '%s\n' "    68     44   EOT           d             68            10000100110  141221"
    printf '%s\n' "    69     45   ENQ           e             69            10110010000  112214"
    printf '%s\n' "    70     46   ACK           f             70            10110000100  112412"
    printf '%s\n' "    71     47   BEL           g             71            10011010000  122114"
    printf '%s\n' "    72     48   BS            h             72            10011000010  122411"
    printf '%s\n' "    73     49   HT            i             73            10000110100  142112"
    printf '%s\n' "    74     4a   LF            j             74            10000110010  142211"
    printf '%s\n' "    75     4b   VT            k             75            11000010010  241211"
    printf '%s\n' "    76     4c   FF            l             76            11001010000  221114"
    printf '%s\n' "    77     4d   CR            m             77            11110111010  413111"
    printf '%s\n' "    78     4e   SO            n             78            11000010100  241112"
    printf '%s\n' "    79     4f   SI            o             79            10001111010  134111"
    printf '%s\n' "    80     50   DLE           p             80            10100111100  111242"
    printf '%s\n' "    81     51   DC1           q             81            10010111100  121142"
    printf '%s\n' "    82     52   DC2           r             82            10010011110  121241"
    printf '%s\n' "    83     53   DC3           s             83            10111100100  114212"
    printf '%s\n' "    84     54   DC4           t             84            10011110100  124112"
    printf '%s\n' "    85     55   NAK           u             85            10011110010  124211"
    printf '%s\n' "    86     56   SYN           v             86            11110100100  411212"
    printf '%s\n' "    87     57   ETB           w             87            11110010100  421112"
    printf '%s\n' "    88     58   CAN           x             88            11110010010  421211"
    printf '%s\n' "    89     59   EM            y             89            11011011110  212141"
    printf '%s\n' "    90     5a   SUB           z             90            11011110110  214121"
    printf '%s\n' "    91     5b   ESC           {             91            11110110110  412121"
    printf '%s\n' "    92     5c   FS            |             92            10101111000  111143"
    printf '%s\n' "    93     5d   GS            }             93            10100011110  111341"
    printf '%s\n' "    94     5e   RS            ~             94            10001011110  131141"
    printf '%s\n' "    95     5f   US            DEL           95            10111101000  114113"
    printf '%s\n' "    96     60   FNC 3         FNC 3         96            10111100010  114311"
    printf '%s\n' "    97     61   FNC 2         FNC 2         97            11110101000  411113"
    printf '%s\n' "    98     62   Shift B       Shift A       98            11110100010  411311"
    printf '%s\n' "    99     63   Code C        Code C        99            10111011110  113141"
    printf '%s\n' "    100    64   Code B        FNC 4         Code B        10111101110  114131"
    printf '%s\n' "    101    65   FNC 4         Code A        Code A        11101011110  311141"
    printf '%s\n' "    102    66   FNC 1         FNC 1         FNC 1         11110101110  411131"
    printf '%s\n' "    103    67   Start Code A  Start Code A  Start Code A  11010000100  211412"
    printf '%s\n' "    104    68   Start Code B  Start Code B  Start Code B  11010010000  211214"
    printf '%s\n' "    105    69   Start Code C  Start Code C  Start Code C  11010011100  211232"
    printf '%s\n' "    106    6a   Stop          Stop          Stop          11000111010  233111"
    printf '\n'
    printf '%s\n' "    Source of this information: https://en.wikipedia.org/wiki/Code_128"
    exit 0
} # end of f_print_mapping

# Print script version.
f_print_version()
{
    printf '%s\n' "${s_program_version}"
    exit 0
} # end of f_print_version

# Inspect script arguments and optionally overwrite defaults.
f_input_parse()
{
    if [ "${1}" = "" ]; then
        f_print_help
    else
        while :; do
            case "${1}" in
                -c|--codeset)
                    # Check if input equals one three valid codesets.
                    if [[ "${2}" = "b" || "${2}" = "c" || "${2}" = "x" ]]; then
                        s_codeset="${2}"
                        shift 2
                    else
                        f_die "Error: \"--codeset\" can only be \"b\", \"c\" or \"x\"."
                    fi
                ;;
                -d|--description)
                    boolean_description=true
                    shift
                ;;
                -i|--invert)
                    boolean_invert=""
                    shift
                ;;
                -p|--padding-vertical)
                    # Check if input is a natural number including zero.
                    if [[ "${2}" =~ ^[0-9]+$ ]]; then
                        int_padding_v="${2}"
                        shift 2
                    else
                        f_die "Error: \"--padding-vertical\" must be a natural number."
                    fi
                ;;
                -s|--size)
                    # Check if input is a natural number including zero.
                    if [[ "${2}" =~ ^[0-9]+$ ]]; then
                        int_size="${2}"
                        shift 2
                    else
                        f_die "Error: \"--size\" must be a natural number."
                    fi
                ;;
                --debug)
                    boolean_debug=true
                    shift
                ;;
                -h|--help)
                    f_print_help
                ;;
                -m|--mapping)
                    f_print_mapping
                ;;
                -v|--version)
                    f_print_version
                ;;
                -*)
                    # Exit in case of invalid argument.
                    f_die "Error: \"${1}\" is not a valid option."
                ;;
                *)
                    # Keep actual data. Discard everything else.
                    s_input="${1}"
                    break
                ;;
            esac
        done
    fi
} # end of f_input_parse

# Convert user input to escaped unicode to unify it.
f_input_escape()
{
    # Build escaped string s_input one by one character.
    for (( i=0; i<"${#s_input}"; i++ )); do
        array_escaped[$i]+=$(printf '\\u%04x' "'${s_input:$i:1}")
    done
} # end of f_input_escape

# Lookup index number of escaped unicode characters in codeset.
f_values_lookup()
{
    # Choose according lookup method for selected codeset.
    if [ "${s_codeset}" = "b" ]; then
        # lookup method for codeset b
        # Add index value of startcode to array_values.
        array_values[0]="${int_startcode_b}"
        # Proceed with user input. Select first unicode value ...
        for i in "${!array_escaped[@]}"; do
            # ... and compare it to every item in codeset.
            for j in "${!array_codeset_b[@]}"; do
                if [[ "${array_codeset_b[$j]}" = "${array_escaped[$i]}" ]]; then
                    # If found, add index value to array_values.
                    array_values+=("${j}")
                    # Also add character to human readable description.
                    s_description+="${array_escaped[$i]}"
                    break
                elif [[ $((j+1)) = "${#array_codeset_b[@]}" ]]; then
                    # If not found, take a closer look and exit.
                    s_invalid_char=$(printf "${array_escaped[$i]}")
                    f_die "Error: Character \"${s_invalid_char}\" is invalid."
                fi
            done
        done
    elif [ "${s_codeset}" = "c" ]; then
        # lookup method for codeset c
        # Add index value of startcode to array_values.
        array_values[0]="${int_startcode_c}"
        # Proceed with user input.
        # Detect if amount of characters of raw user input is odd.
        # This is important because a remaining single digit can only be
        # encoded by switching to codeset b for the very last character.
        if (( "${#array_escaped[@]}" % 2 )); then
            # Get last item of escaped input.
            s_last_character="${array_escaped[${#array_escaped[@]}-1]}"
            # Compare it to every item in codeset b.
            for k in "${!array_digits[@]}"; do
                if [[ "${array_digits[$k]}" = "${s_last_character}" ]]; then
                    # If found, note according index value plus array offset.
                    int_last_character=$((k+16))
                    # Also remove item from escaped array to make it even.
                    unset 'array_escaped[${#array_escaped[@]}-1]'
                    break
                elif [[ $((k+1)) = "${#array_digits[@]}" ]]; then
                    # If not found, take a closer look and exit.
                    s_invalid_char=$(printf "${s_last_character}")
                    f_die "Error: Character \"${s_invalid_char}\" is invalid."
                fi
            done
        fi
        # Proceed with an even amount of characters and build pairs.
        for m in "${!array_escaped[@]}"; do
            # Check if character is first of two in a pair.
            if [ "${boolean_1st}" ]; then
                # Add first character to a pair and start next iteration.
                s_pair="${array_escaped[$m]}"
                boolean_1st=
                continue
            else
                # Add second character to the pair and store in array.
                s_pair+="${array_escaped[$m]}"
                boolean_1st=true
                array_pairs+=("${s_pair}")
            fi
        done
        # Do lookup of digit pairs.
        for n in "${!array_pairs[@]}"; do
            # Compare them to every item in codeset.
            for o in "${!array_codeset_c[@]}"; do
                if [[ "${array_codeset_c[$o]}" = "${array_pairs[$n]}" ]]; then
                    # If found, add index value to array_values.
                    array_values+=("${o}")
                    # Also add digit pair to human readable description.
                    s_description+="${array_pairs[$n]}"
                    break
                elif [[ $((o+1)) = "${#array_codeset_c[@]}" ]]; then
                    # If not found, take a closer look and exit.
                    s_invalid_char=$(printf "${array_pairs[$n]}")
                    f_die "Error: Character pair \"${s_invalid_char}\" is invalid."
                fi
            done
        done
        # Do not forget to add remaining codeset b character if there is any.
        if ! [ "${s_last_character}" = "" ]; then
            # Add index value of codeset b to array_values.
            array_values+=("${int_code_b}")
            # Add index value to array_values.
            array_values+=("${int_last_character}")
            # Add last character to human readable description.
            s_description+="${s_last_character}"
            # Add last character to escaped ones again for debugging.
            array_escaped+=("${s_last_character}")
        fi
    elif [ "${s_codeset}" = "x" ]; then
        # Replace commas with whitespace.
        temp="${s_input//\,/\ }"
        temp="${temp//\;/\ }"
        # Write separated values to corresponding array.
        IFS=' '
        read -a array_values <<< "${temp}"
        # Check if array contains only valid index numbers.
        for p in "${!array_values[@]}"; do
            # Check if current item is a number.
            if [[ "${array_values[$p]}" =~ ^[0-9]+$ ]]; then
                # Check if number is within valid range.
                if ! (("${array_values[$p]}" >= 0
                     && "${array_values[$p]}" <= 106)); then
                    f_die "Error: Value \"${array_values[$p]}\" is not within the valid range from 0 to 106."
                fi
            else
                f_die "Error: \"${array_values[$p]}\" is not a number."
            fi
        done
    else
        # This will only be visible if argument parser is drunk.
        f_die "Error: Something went very wrong here."
    fi
} # end of f_values_lookup

# Calculate modulo 103 checksum.
f_values_checksum()
{
    for i in "${!array_values[@]}"; do
        # Check if we currently handle startcode or user input.
        if [[ $i = 0 ]]; then
            # Value of startcode is always multiplied by 1.
            # It is always first and initial value of checksum.
            int_checksum=$(("${int_checksum}" + ("${array_values[$i]}" * 1)))
        else
            # Value of any string data is multiplied by its array index.
            # Product is then added to sum of previous ones.
            int_checksum=$(("${int_checksum}" + ("${array_values[$i]}" * i)))
        fi
    done
    # Calculate final checksum, remainder of division by 103.
    int_checksum=$(("${int_checksum}" % 103))
} # end of f_values_checksum

# Complete array of values by adding checksum and stopcode.
f_values_completion()
{
    array_values+=("${int_checksum}")
    array_values+=("${int_stop}")
} # end of f_values_completion

# Lookup binary patterns for unicode block elements plus quietzones.
f_patterns_collect()
{
    # Add leading quietzone.
    s_binaries+="${s_quietzone}"
    # Add charater patterns.
    for i in "${!array_values[@]}"; do
        s_binaries+="${array_patterns[${array_values[$i]}]}"
    done
    # Add final bar.
    s_binaries+="${s_final_bar}"
    # Add trailing quietzone.
    s_binaries+="${s_quietzone}"
} # end of f_patterns_collect

# Invert binary patterns because terminals are traditionally dark themed.
f_patterns_invert()
{
    s_binaries="${s_binaries//0/n}"
    s_binaries="${s_binaries//1/0}"
    s_binaries="${s_binaries//n/1}"
} # end of f_patterns_invert

# Translate binary string to final unicode block elements.
f_unicode_translate()
{
    for (( i=0; i<"${#s_binaries}"; i=i+2 )); do
        temp="${s_binaries:$i:2}"
        if [ "${temp}" = "00" ]; then
            s_unicodeblocks+="\u0020"
        elif [ "${temp}" = "01" ]; then
            s_unicodeblocks+="\u2590"
        elif [ "${temp}" = "10" ]; then
            s_unicodeblocks+="\u258c"
        elif [ "${temp}" = "11" ]; then
            s_unicodeblocks+="\u2588"
        elif [ "${temp}" = "0" ]; then
            s_unicodeblocks+=""
        elif [ "${temp}" = "1" ]; then
            s_unicodeblocks+="\u2588"
        else
            s_unicodeblocks+="\u0065"
        fi
    done
} # end of f_unicode_translate

# Detect length of human readable description.
f_description_count()
{
    # Take a closer look at the string.
    temp=$(printf "${s_description}")
    int_description_length="${#temp}"
} # end of f_description_count

# Detect length of final unicode block element lines.
f_unicode_count()
{
    # Take a closer look at the string.
    temp=$(printf "${s_unicodeblocks}")
    int_barcode_length="${#temp}"
} # end of f_unicode_count

# Choose unicode block element for padding regarding color inversion.
f_padding_color()
{
    if [ "${boolean_invert}" ]; then
        s_padding_character="\u2588"
    else
        s_padding_character="\u0020"
    fi
} # end of f_padding_color

# Optionally print information about some intermediate stages.
f_print_debug()
{
    printf '%s\n' "Raw user input in human readable format (s_input):"
    printf '%s\n' "${s_input}"
    printf '\n'
    printf '%s\n' "Raw user input in Unicode format (array_escaped):"
    echo "${array_escaped[@]}"
    printf '\n'
    printf '%s\n' "Modulo 103 checksum (int_checksum):"
    printf '%s\n' "${int_checksum}"
    printf '\n'
    printf '%s\n' "Codeset index values of unicode characters (array_values):"
    echo "${array_values[@]}"
    printf '\n'
    printf '%s\n' "Graphical barcode in binary format (s_binaries):"
    printf '%s\n' "${s_binaries}"
    printf '\n'
    printf '%s\n' "Graphical barcode in Unicode format (s_unicodeblocks):"
    echo "${s_unicodeblocks}"
    printf '\n'
    printf '%s\n' "Length of graphical barcode in characters:"
    printf '%s\n' "${int_barcode_length}"
    printf '\n'
    printf '%s\n' "Final printed result:"
} # end of of f_print_debug

# This will print i padding characters to fill up screen space.
print_padding_character()
{
    for (( j=0; j<"${1}"; j++ )); do
        printf "${s_padding_character}"
    done
} # end of print_padding_character

# This is just for aesthetics, it will make the barcode look prettier.
f_print_padding_line()
{
    for (( i=0; i<"${1}"; i++ )); do
        print_padding_character "${int_barcode_length}"
        printf '\n'
    done
} # end of f_print_padding_line

# Print actual barcode times chosen size of lines.
f_print_result()
{
    f_print_padding_line "${int_padding_v}"
    for (( i=0; i<"${int_size}"; i++ )); do
        printf "${s_unicodeblocks}\n"
    done
} # end of f_print_result

# Print a human readable description.
f_print_description()
{
    # Separate barcode and text if there is enough padding.
    if [[ "${int_padding_v}" -gt 2 ]]; then
        f_print_padding_line 1
    fi
    # Print leading padding characters.
    print_padding_character $(("${int_barcode_length}"/2-
    "${int_description_length}"/2-1))
    # Print descriptive text.
    printf " ${s_description} "
    # Print trailing padding characters.
    print_padding_character $(("${int_barcode_length}"-
        "${int_barcode_length}"/2+"${int_description_length}"/2-
        "${int_description_length}"-1))
    printf '\n'

} # end of f_print_description

# ------------------------------------------------------------------------------
# END_OF_FUNCTIONS
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# MAIN
# ------------------------------------------------------------------------------

# Split user input into arguments and data.
f_input_parse "${@}"
# Process user data in various ways.
f_input_escape "${s_input}"
f_values_lookup
f_values_checksum
f_values_completion
f_patterns_collect
if [ "${boolean_invert}" ]; then
    f_patterns_invert
fi
f_unicode_translate
# Prepare for printing.
f_unicode_count
f_description_count
f_padding_color
# Optionally print debug information.
if [ "${boolean_debug}" ]; then
    f_print_debug
fi
# Print barcode.
f_print_result
# Optionally print description.
# Only do so, if there is enough padding.
if [[ "${boolean_description}" && "${int_padding_v}" -gt 0 ]]; then
    # And also only do so, if codeset b or c is used.
    if [[ "${s_codeset}" = "b" || "${s_codeset}" = "c" ]]; then
        f_print_description
        if (( "${int_padding_v}" >= 3 )); then
            f_print_padding_line $(("${int_padding_v}"-2))
        else
            f_print_padding_line $(("${int_padding_v}"-1))
        fi
    else
        f_print_padding_line "${int_padding_v}"
    fi
else
    f_print_padding_line "${int_padding_v}"
fi

# ------------------------------------------------------------------------------
# END_OF_MAIN
# ------------------------------------------------------------------------------

