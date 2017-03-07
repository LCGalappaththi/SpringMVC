package com.lcg.dao;

public class IDGenerator {
    public static String idGenarator(String prefix,String oldId){
        String s2 = oldId.substring(1);
        long x = Long.parseLong(s2);
        x++;
        String s3 = "";
        if (x < 10) {
            s3 = prefix + "00000000" + String.valueOf(x);
        } else if (x < 100) {
            s3 = prefix + "0000000" + String.valueOf(x);
        }
        else if (x < 1000) {
            s3 = prefix + "000000" + String.valueOf(x);
        }
        else if (x < 10000) {
            s3 = prefix + "00000" + String.valueOf(x);
        }
        else if (x < 100000) {
            s3 = prefix + "0000" + String.valueOf(x);
        }
        else if (x < 1000000) {
            s3 = prefix + "000" + String.valueOf(x);
        }
        else if (x < 10000000) {
            s3 = prefix + "00" + String.valueOf(x);
        }
        else if (x < 100000000) {
            s3 = prefix + "0" + String.valueOf(x);
        }
        else if (x < 1000000000) {
            s3 = prefix + String.valueOf(x);
        }
        s3 = s3.trim();
        return s3;
    }
}