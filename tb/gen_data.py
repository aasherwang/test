import os
import random

def gen_data(min_value,max_value,data_num):
    data = []
    for data_idx in range(data_num):
        tmp = random.randint(min_value,max_value)
        #tmp = data_idx % 128
        data.append(tmp)
    return data

def write_orig_data(file_name,data,data_num_pre_line):
    line_num = (len(data) + data_num_pre_line -1) // data_num_pre_line
    with open(file_name,'a') as f:
        for line_idx in range(line_num):
            for data_idx in range(data_num_pre_line):
                f.write("{:0>2x}". format(data[line_idx * data_num_pre_line + data_idx] & 0xFF))
                print(data[line_idx * data_num_pre_line + data_idx])
            f.write('\r\n')

def pack_8x8(data_array):
    blk_8x8_num = (len(data_array) + 63) // 64
    pack_data   = []
    for blk_8x8_idx in range(blk_8x8_num):
        blk_8x8_data = []
        for row_idx in range(8):
            row_data = []
            for col_idx in range(8):
                data_idx = blk_8x8_idx * 64 + row_idx * 8 + col_idx
                if(data_idx >= len(data_array)):
                    row_data.append(0)
                else:
                    row_data.append(data_array[data_idx])
            blk_8x8_data.append(row_data)
        pack_data.append(blk_8x8_data)
    return pack_data

def get_row(blk_data,row_idx):
    return blk_data[row_idx]

def get_col(blk_data,col_idx):
    col_data = []
    for row_idx in range(8):
        col_data.append(blk_data[row_idx][col_idx])
    return col_data

def write_orig_blk_8x8_data(data_path,filename_key_word,data_array_8x8,char_num):
    filename = data_path + filename_key_word + '_data.txt'
    with open(filename,'a') as f:
        for row_idx in range(0,8,2):
            for col_idx in range(7,-1,-1):
                if(char_num == 2):
                    f.write("{:0>2x}". format(data_array_8x8[row_idx+1][col_idx] & 0xFF))
                elif(char_num == 3):
                    f.write("{:0>3x}". format(data_array_8x8[row_idx+1][col_idx] & 0xFFF))
                elif(char_num == 4):
                    f.write("{:0>4x}". format(data_array_8x8[row_idx+1][col_idx] & 0xFFFF))
                else:
                    f.write("{:0>5x}". format(data_array_8x8[row_idx+1][col_idx] & 0xFFFFF))
            
            for col_idx in range(7,-1,-1):
                if(char_num == 2):
                    f.write("{:0>2x}". format(data_array_8x8[row_idx][col_idx] & 0xFF))
                elif(char_num == 3):
                    f.write("{:0>3x}". format(data_array_8x8[row_idx][col_idx] & 0xFFF))
                elif(char_num == 4):
                    f.write("{:0>4x}". format(data_array_8x8[row_idx][col_idx] & 0xFFFF))
                else:
                    f.write("{:0>5x}". format(data_array_8x8[row_idx][col_idx] & 0xFFFFF))

            f.write('\r\n')

def write_blk_8x8_data(data_path,filename_key_word,data_array_8x8,char_num):
    vect_0246_filename = data_path + filename_key_word + '_0246_data.txt'
    vect_1357_filename = data_path + filename_key_word + '_1357_data.txt'
            
    with open(vect_0246_filename,'a') as f:
        for row_idx in range(0,8,2):
            for col_idx in range(7,-1,-1):
                #print('row_idx                          is ',row_idx                         )
                #print('col_idx                          is ',col_idx                         )
                #print('data_array_8x8[row_idx][col_idx] is ',data_array_8x8[row_idx][col_idx])
                if(char_num == 2):
                    f.write("{:0>2x}". format(data_array_8x8[row_idx][col_idx] & 0xFF))
                elif(char_num == 3):
                    f.write("{:0>3x}". format(data_array_8x8[row_idx][col_idx] & 0xFFF))
                elif(char_num == 4):
                    f.write("{:0>4x}". format(data_array_8x8[row_idx][col_idx] & 0xFFFF))
                else:
                    f.write("{:0>5x}". format(data_array_8x8[row_idx][col_idx] & 0xFFFFF))
            f.write('\r\n')
                
    with open(vect_1357_filename,'a') as f:
        for row_idx in range(1,8,2):
            for col_idx in range(7,-1,-1):
                #print('row_idx                          is ',row_idx                         )
                #print('col_idx                          is ',col_idx                         )
                #print('data_array_8x8[row_idx][col_idx] is ',data_array_8x8[row_idx][col_idx])
                if(char_num == 2):
                    f.write("{:0>2x}". format(data_array_8x8[row_idx][col_idx] & 0xFF))
                elif(char_num == 3):
                    f.write("{:0>3x}". format(data_array_8x8[row_idx][col_idx] & 0xFFF))
                elif(char_num == 4):
                    f.write("{:0>4x}". format(data_array_8x8[row_idx][col_idx] & 0xFFFF))
                else:
                    f.write("{:0>5x}". format(data_array_8x8[row_idx][col_idx] & 0xFFFFF))
            f.write('\r\n')


def transpose_mitrix(src_mitrix):
    dst_mitrix = []
    for col_idx in range(8):
        col_data = get_col(src_mitrix,col_idx)
        dst_mitrix.append(col_data)
    return dst_mitrix

def dct_8x8_blk_cal(blk_8x8_data):
    blk_cal_result = []
    for vector_idx in range(8):
        vector_in = blk_8x8_data[vector_idx]
        vector_out= dct_8x8_vector_cal(vector_in)
        blk_cal_result.append(vector_out)
    return blk_cal_result

def dct_8x8_vector_cal(vector_in):
    p0 = vector_in[0] + vector_in[7]
    p1 = vector_in[3] - vector_in[4]
    p2 = vector_in[1] + vector_in[6]
    p3 = vector_in[2] - vector_in[5]
    p4 = vector_in[2] + vector_in[5]
    p5 = vector_in[1] - vector_in[6]
    p6 = vector_in[3] + vector_in[4]
    p7 = vector_in[0] - vector_in[7]

    q0 =  p0        +  p6
    q1 =  p1        - (p7 >> 2)
    q2 =  p2        +  p4
    q3 =  p3        + (p5 >> 2)
    q4 =  p2        -  p4
    q5 = (p3 >> 2)  -  p5
    q6 =  p0        -  p6
    q7 = (p1 >> 2)  +  p7

    o0 = q0 + q2
    o1 = q3 - q5 + q7 + (q7>>1)
    o2 = (q4 >> 1) + q6
    o3 = -q1 -q3 - (q3 >> 1) + q7
    o4 = q0 - q2
    o5 = q1 + q5 + (q5 >> 1) + q7
    o6 = -q4 + (q6 >> 1)
    o7 = -q1 - (q1 >> 1) + q3 + q5

    vector_out = [o0,o1,o2,o3,o4,o5,o6,o7]

    return vector_out


if __name__ == '__main__':
    data_path = '../data/'
    orig_data_filename    = data_path + 'orig_data.txt'

    cmd = 'rm -rf ' + data_path + '*.txt'
    print(cmd)
    os.system(cmd)

    data_array      = gen_data(-128,127,8*8*4)
    data_array_8x8  = pack_8x8(data_array)
    write_orig_data(orig_data_filename,data_array,1)

    for blk_idx in range(len(data_array_8x8)):
        blk_8x8_data = data_array_8x8[blk_idx]
        write_orig_blk_8x8_data(data_path,'blk_8x8_orig',blk_8x8_data,2)
        blk_8x8_data_1d = dct_8x8_blk_cal(blk_8x8_data)
        write_blk_8x8_data(data_path,'blk_8x8_1d_row',blk_8x8_data_1d,3)
        blk_8x8_data_1d_tm = transpose_mitrix(blk_8x8_data_1d)
        write_blk_8x8_data(data_path,'blk_8x8_1d_col',blk_8x8_data_1d_tm,3)
        blk_8x8_data_2d    = dct_8x8_blk_cal(blk_8x8_data_1d_tm)
        write_blk_8x8_data(data_path,'blk_8x8_2d_col',blk_8x8_data_2d,4)
        blk_8x8_data_2d_tm = transpose_mitrix(blk_8x8_data_2d)
        write_blk_8x8_data(data_path,'blk_8x8_2d_row',blk_8x8_data_2d_tm,4)

