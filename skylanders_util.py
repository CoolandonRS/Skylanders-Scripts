import re
import sys
import struct
import argparse
import binascii

debug = False;

def main():
    description = "Various utilities for skylanders, such as generating keys."
    examples = """
        script run skylanders_util -m genkeys -u DEADBEEF
    """

    parser = argparse.ArgumentParser(description=description, epilog="Examples: \n" + examples, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("-m", "--mode", required=True, type=str, help="The mode to operate in. One of: genkeys")
    parser.add_argument("-u", "--uid", required=False, type=str, default=None, help="The uid of the toy. Required by: genkeys")
    parser.add_argument("-o", "--output", required=False, type=argparse.FileType('w'), default=sys.stdout, help="File to output to")
    args = parser.parse_args();

    if args.mode == "genkeys":
        generate_keys(args.uid, args.output)
    else:
        print("ERROR: Unknown mode")
        exit(1)

#region actions
def generate_keys(uid, outFile):
    if uid is None:
        print("Error: No UID provided")
        exit(1)
    if uidRgx.match(uid) is None:
        print("Error: Invalid UID provided")
        exit(1)

    for key in calc_keys(unpack_uid(uid)):
        keyStr = binascii.hexlify(struct.pack('<Q', key)).decode('ascii')[0:12]
        outFile.write(f'{keyStr}\n')
    
    
#endregion actions

#region generate_keys helpers
# most of this is reimplemented/copied from https://github.com/DevZillion/TheSkyLib/blob/main/libs/tnp3xxx.py
magic = [2, 3, 73, 1103, 2017, 560381651, 12868356821]
uidRgx = re.compile('^[0-9a-f]{8}$', re.IGNORECASE)
sector0 = 0xcb7c10200b4b # swap_endianness(magic[2] * magic[4] * magic[5])
crc_pre = magic[0] * magic[0] * magic[1] * magic[3] * magic[6]
crc_poly = 0x42f0e1eba9ea3693
crc_msb = 0x800000000000
crc_trim = 0xffffffffffff

def unpack_uid(uidStr):
    return list(struct.unpack('<BBBB', bytes.fromhex(uidStr)))

def calc_keys(uid):
    keys = []
    for i in range(0, 16):
        keys.append(calc_keya(uid, i))
    return keys

def calc_keya(uid, sector):
    if sector == 0:
        return sector0
    return pseudo_crc48(uid + [sector])

def pseudo_crc48(data):
    crc = crc_pre
    for n in data:
        crc ^= n << 40
        for _ in range(0, 8):
            if crc & crc_msb:
                crc = (crc << 1) ^ crc_poly
            else:
                crc <<= 1
            crc &= crc_trim
    return crc


#endregion generate_keys helpers


if __name__ == '__main__':
    main()
    exit(0)