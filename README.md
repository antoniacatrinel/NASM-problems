# NASM problems

1.  Given 4 bytes, compute in AX the sum of the integers represented by the bits 4-6 of the 4 bytes.

2.  Given the quadword A, obtain the integer number N represented on the bits 17-19 of A. Then obtain the doubleword B by rotating the high doubleword of A N positions to the left. Obtain the byte C as follows:
     * the bits 0-2 of C are the same as the bits 9-11 of B
     * the bits 3-7 of C are the same as the bits 20-24 of B

3.  A byte string S is given. Obtain the string D1 which contains the elements found on the even positions of S and the string D2 which contains the elements found on the odd positions of S.\
***Example:***\
    &emsp;posS: 0, 1, 2, 3, 4, 5\
    &emsp;S: 1, 5, 3, 8, 2, 9\
    &emsp;D1: 1, 3, 2\
    &emsp;D2: 5, 8, 9

4.  Two character strings S1 and S2 are given. Obtain the string D by concatenating the elements found on the positions multiple of 3 from S1 and the elements of S2 in reverse order.\
***Example***:\
   &emsp;pos:  0,   1,   2,   3,   4,   5,   6,   7\
    &emsp;S1: '+', '4', '2', 'a', '8', '4', 'X', '5'\
    &emsp;S2: 'a', '4', '5'\
     &emsp;D: '+', 'a', 'X', '5', '4', 'a'

5.  An array of doublewords, where each doubleword contains 2 values on a word (unpacked, so each nibble is preceded by a 0) is given. Write an asm program to create a new array of bytes which contain those values (packed on a single byte), arranged in an ascending manner in memory, these being considered signed numbers.\
***Example***:\
  &emsp;initial array: 0702090Ah, 0B0C0304h, 05060108h\
  &emsp;result: 72h, 9Ah, 0BCh, 34h, 56h, 18h\ 
  &emsp;result in arranged manner: 9Ah, 0BCh, 18h, 34h, 56h, 72h
 
 6.  Given an array S of doublewords, build the array of bytes D formed from lower bytes of lower words, bytes multiple of 7.\
***Example***:\
     &emsp;s DD 1234_5607h, 1A2B_3C15h, 13A3_3412h\
     &emsp;d DB 07h, 15h

7.  Given an array S of doublewords, build the array of bytes D formed from bytes of doublewords sorted as unsigned numbers in ascending order.\
***Example***:\
     &emsp;s DD 1234_5607h, 1A2B_3C15h\
     &emsp;d DB 07h, 12h, 15h, 1Ah, 2Bh, 34h, 3Ch, 56h\
 
 8.  Two strings of bytes A and B are given. Parse the shortest string of those two and build a third string C as follows:
       - up to the length of the shortest string C contains the largest element of the same rank from the two strings
       - then, up to the length of the longest string C will be filled with 1 and 0, alternatively.\
***Example***:\
     &emsp;a db 4h, 28h, 16h, 18h, 6h, 8h\
     &emsp;b db 24h, 22h, 10h\
     &emsp;resulted string: c -> 24h, 28h, 16h, 01h, 00h, 01h
 
 9.  A text file is given. Read the content of the file, count the number of vowels and display the result on the screen. The name of text file is defined in the data segment.
 
 10.  A text file is given. Read the content of the file, count the number of consonants and display the result on the screen. The name of text file is defined in the data segment.
 
 11.  A text file is given. Read the content of the file, count the number of even digits and display the result on the screen. The name of text file is defined in the data segment.
 
 12.  A text file is given. Read the content of the file, count the number of odd digits and display the result on the screen. The name of text file is defined in the data segment.
 
 13.  A text file is given. Read the content of the file, count the number of special characters and display the result on the screen. The name of text file is defined in the data segment.
 
 14.  A text file is given. Read the content of the file, determine the digit with the highest frequency and display the digit along with its frequency on the screen. The name of text file is defined in the data segment.
 
 15.  A text file is given. Read the content of the file, determine the lowercase letter with the highest frequency and display the letter along with its frequency on the screen. The name of text file is defined in the data segment.
 
 16.  A text file is given. Read the content of the file, determine the uppercase letter with the highest frequency and display the letter along with its frequency on the screen. The name of text file is defined in the data segment.
 
 17.  A text file is given. Read the content of the file, determine the special character with the highest frequency and display the character along with its frequency on the screen. The name of text file is defined in the data segment.
 
 18.  Read a file name and a text from the keyboard. Create a file with that name in the current folder and write the text that has been read to file. Observations: The file name has maximum 30 characters. The text has maximum 120 characters.
 
 19.  A text file is given. The text file contains numbers (in base 10) separated by spaces. Read the content of the file, determine the maximum number (from the numbers that have been read) and write the result at the end of file.
 
 20.  Read two numbers a and b (in base 16) from the keyboard and calculate a+b. Display the result in base 10.
 
 21.  Read from keyboard a file name, a special character s (besides letters and numbers) and a number n on a byte. 
The file contains words separated by space. Write in file output.txt the words transformed in the following way: 
        * the n- th character of each word is transformed into the special character.
        * if the number of characters of ha word is smaller than n, prefix the word with the special character.\
***Example***:\
     &emsp;File name : input.txt\
     &emsp;file content : mere pere banane mandarine\
     &emsp;s: +\
     &emsp;n: 6\
     &emsp;output.txt: ++mere ++pere banan+ manda+

22.  A file is given. Replace all lowercase letters with their ascii code and write the content to another file.

23.  Read grades from a given file and compute the sum and the difference of all grades and print them at the end of the file.

24.  Given a file name, a character and a number, display in an output file the characters from the file with the number of occurences equal to the read number.

25.  Multi-modul programming (asm+asm): Read a sentence from the keyboard. For each word, obtain a new one by taking the letters in reverse order and print each new word.
