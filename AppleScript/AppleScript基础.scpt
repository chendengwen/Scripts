FasdUAS 1.101.10   ��   ��    k             l      ��  ��    ; 5  Shell?Terminal???AppleScript?? osascript aaa.scpt       � 	 	 j     S h e l lb T e r m i n a lN-�ЈL A p p l e S c r i p te�N�   o s a s c r i p t   a a a . s c p t       
  
 l      ��  ��    5 /  AppleScript???Shell?? do shell script "ps A"      �   ^     A p p l e S c r i p tN-�ЈL S h e l le�N�   d o   s h e l l   s c r i p t   " p s   A "        l      ��  ��    ? 9 ??????????AppleScript???shell?/bin/sh?????????/bin/bash      �   r  g	N p�� ��h<Yl�a� A p p l e S c r i p tv��؋� s h e l lf/ / b i n / s h�bN�u(v�~�z�Rf/ / b i n / b a s h        l     ��������  ��  ��        l      ��  ��    � � ??: ????
?tell????????????beep?say??current application??????????--

say "How are you" 

-- ?????? ->using "Victoria" 
say "Fine, thank you." using "Victoria" 

-- ?Mac???????? ->beep ????
beep

     �  �  y:O� :  �u(��� 
W( t e l lj!WWN-v�N�aOMnS�N�c�Qe b e e p� s a y{Iu1 c u r r e n t   a p p l i c a t i o nz^����bg�Lv���S�0 - - 
 
 s a y   " H o w   a r e   y o u "   
 
 - -  S�N�c[�X��   - > u s i n g   " V i c t o r i a "   
 s a y   " F i n e ,   t h a n k   y o u . "   u s i n g   " V i c t o r i a "   
 
 - -  �� M a c|�~�S�Q�T�v�X��   - > b e e p  S�X�k!ep 
 b e e p 
 
      l     ��������  ��  ��        l      ��   ��   D> Finder??
	(* ?????
		??1.
			activate  #activate :????????
			make new Finder window
		
		??2.
			tell app "Finder" to make new Finder window
	*)
	(* ????
		??1. ??????
			open file filePath  #open file/folder/alias filePath
		??2. ????
			open folder "mac:Users:mac:Desktop"
	*)
	(* ???????
		set filePath to file "mac:Users:mac:Desktop:11.png"
		set comment of filePath to "??????"
	*)
	(* ????app
		tell application "Finder"		set myAppFolder to the path to the applications folder		set myApp to application file "TextEdit.app" of myAppFolder		open myAppend tell
	*)
      � ! !|   F i n d e rd�O\ 
 	 ( *  bS_ e�z�S� 
 	 	e�_ 1 . 
 	 	 	 a c t i v a t e     # a c t i v a t e   :o�m;c[�v�z�S�0 
 	 	 	 m a k e   n e w   F i n d e r   w i n d o w 
 	 	 
 	 	e�_ 2 . 
 	 	 	 t e l l   a p p   " F i n d e r "   t o   m a k e   n e w   F i n d e r   w i n d o w 
 	 * ) 
 	 ( *  bS_ e�N� 
 	 	e�_ 1 .  S�ep��S֍�_� 
 	 	 	 o p e n   f i l e   f i l e P a t h     # o p e n   f i l e / f o l d e r / a l i a s   f i l e P a t h 
 	 	e�_ 2 .  ~�[���_� 
 	 	 	 o p e n   f o l d e r   " m a c : U s e r s : m a c : D e s k t o p " 
 	 * ) 
 	 ( *  ~�e�N�m�R�l�� 
 	 	 s e t   f i l e P a t h   t o   f i l e   " m a c : U s e r s : m a c : D e s k t o p : 1 1 . p n g " 
 	 	 s e t   c o m m e n t   o f   f i l e P a t h   t o   "�g,m�R�l�� " 
 	 * ) 
 	 ( *  bS_ N�a a p p 
 	 	 t e l l   a p p l i c a t i o n   " F i n d e r "  	 	 s e t   m y A p p F o l d e r   t o   t h e   p a t h   t o   t h e   a p p l i c a t i o n s   f o l d e r  	 	 s e t   m y A p p   t o   a p p l i c a t i o n   f i l e   " T e x t E d i t . a p p "   o f   m y A p p F o l d e r  	 	 o p e n   m y A p p  e n d   t e l l 
 	 * ) 
   " # " l     ��������  ��  ��   #  $ % $ l     �� & '��   &   ??????????tell????    ' � ( ( &  z^�bg�Lv���S�_Ř{W( t e l lj!WWNKQ� %  ) * ) l     +���� + O      , - , l   �� . /��   .  open startup disk    / � 0 0 " o p e n   s t a r t u p   d i s k - m      1 1�                                                                                  MACS  alis    .  mac                            BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p    m a c  &System/Library/CoreServices/Finder.app  / ��  ��  ��   *  2 3 2 l     ��������  ��  ��   3  4 5 4 l     �� 6 7��   6   ???????????????    7 � 8 8    �u(~�z�bS_ e�N�^vbg�Lc[��g, 5  9 : 9 l    ;���� ; O     < = < k     > >  ? @ ? l   �� A B��   A , &set newTab to do script "cd ~/Desktop"    B � C C L s e t   n e w T a b   t o   d o   s c r i p t   " c d   ~ / D e s k t o p " @  D�� D l   �� E F��   E / )do script "./yourfile.py" in front window    F � G G R d o   s c r i p t   " . / y o u r f i l e . p y "   i n   f r o n t   w i n d o w��   = m     H H�                                                                                      @ alis    *  mac                            BD ����Terminal.app                                                   ����            ����  
 cu             	Utilities   &/:Applications:Utilities:Terminal.app/    T e r m i n a l . a p p    m a c  #Applications/Utilities/Terminal.app   / ��  ��  ��   :  I J I l     ��������  ��  ��   J  K L K l     ��������  ��  ��   L  M N M l     �� O P��   O &   set to???????, ->set ??? to ???    P � Q Q @   s e t   t o��S�N:SؑύKP< ,   - > s e t  Sؑ�T   t o  Sؑ�P< N  R S R l     �� T U��   T   1). number    U � V V    1 ) .   n u m b e r S  W X W l    Y���� Y r     Z [ Z m    ���� 
 [ o      ���� 0 x  ��  ��   X  \ ] \ l    ^���� ^ r     _ ` _ a     a b a o    ���� 0 x   b m    ����  ` o      ���� 0 x3  ��  ��   ]  c d c l     ��������  ��  ��   d  e f e l     �� g h��   g   2). string    h � i i    2 ) .   s t r i n g f  j k j l    l���� l r     m n m m     o o � p p 
 h e l l o n o      ���� 0 hellostring helloString��  ��   k  q r q l    s���� s r     t u t m     v v � w w    u o      ���� 0 spacestring spaceString��  ��   r  x y x l    # z���� z r     # { | { m     ! } } � ~ ~ 
 w o r l d | o      ���� 0 worldstring worldString��  ��   y   �  l  $ + ����� � r   $ + � � � b   $ ) � � � b   $ ' � � � o   $ %���� 0 hellostring helloString � o   % &���� 0 spacestring spaceString � o   ' (���� 0 worldstring worldString � o      ���� 0 
helloworld  ��  ��   �  � � � l  , 1 ����� � I  , 1�� ���
�� .sysottosnull���     TEXT � o   , -���� 0 
helloworld  ��  ��  ��   �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �   3). number?string???????    � � � � 2   3 ) .   n u m b e rT� s t r i n gNK��v�|{W�N�cb �  � � � l  2 7 ����� � r   2 7 � � � c   2 5 � � � m   2 3���� d � m   3 4��
�� 
TEXT � o      ����  0 numbertostring numberToString��  ��   �  � � � l  8 C ����� � r   8 C � � � c   8 ? � � � m   8 ; � � � � �  1 0 � m   ; >��
�� 
nmbr � o      ����  0 stringtonumber stringToNumber��  ��   �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �   4). ????� \ �    � � � �    4 ) .  �lNI[W{&    \    �  � � � l     �� � ���   � . ( display dialog "\"" & helloworld & "\""    � � � � P   d i s p l a y   d i a l o g   " \ " "   &   h e l l o w o r l d   &   " \ " " �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �   5). ????????    � � � �    5 ) .  [W{&N2Sؑ�v��^� �  � � � l  D M ����� � r   D M � � � l  D I ����� � n   D I � � � 1   E I��
�� 
leng � o   D E���� 0 
helloworld  ��  ��   � o      ���� 0 stringlenght stringLenght��  ��   �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �   6). ??? Dialog    � � � �    6 ) .  [���hF   D i a l o g �  � � � l      �� � ���   �;5 ??
	display dialog "????" buttons {"??1", "??2", ...} default button "???"
	??:
	display dialog "??????" buttons {"Cancel", "11", "22"} default button 3
	if the button returned of the result is "" then
		action for 1st button goes here
	else if ?? then 
		...
	else
		action for 2nd button goes here
	end if
    � � � �j  u(l� 
 	 d i s p l a y   d i a l o g   "c�y:e�[W "   b u t t o n s   { "c	�� 1 " ,   "c	�� 2 " ,   . . . }   d e f a u l t   b u t t o n   "c	��T " 
 	y:O� : 
 	 d i s p l a y   d i a l o g   "��dN�`�f/T' "   b u t t o n s   { " C a n c e l " ,   " 1 1 " ,   " 2 2 " }   d e f a u l t   b u t t o n   3 
 	 i f   t h e   b u t t o n   r e t u r n e d   o f   t h e   r e s u l t   i s   " "   t h e n 
 	 	 a c t i o n   f o r   1 s t   b u t t o n   g o e s   h e r e 
 	 e l s e   i f  gaN�   t h e n   
 	 	 . . . 
 	 e l s e 
 	 	 a c t i o n   f o r   2 n d   b u t t o n   g o e s   h e r e 
 	 e n d   i f 
 �  � � � l  N U ����� � I  N U�� ���
�� .sysodlogaskr        TEXT � m   N Q � � � � � , W e l c o m e   t o   A p p l e S c r i p t��  ��  ��   �  ��� � l     ��������  ��  ��  ��       �� � ��� � o v } � �������������������   � ����������������~�}�|�{�z�y�x�w
�� .aevtoappnull  �   � ****�� 0 x  �� 0 x3  �� 0 hellostring helloString�� 0 spacestring spaceString�� 0 worldstring worldString�� 0 
helloworld  �  0 numbertostring numberToString�~  0 stringtonumber stringToNumber�} 0 stringlenght stringLenght�|  �{  �z  �y  �x  �w   � �v ��u�t � ��s
�v .aevtoappnull  �   � **** � k     U � �  ) � �  9 � �  W � �  \ � �  j � �  q � �  x � �   � �  � � �  � � �  � � �  � � �  ��r�r  �u  �t   �   �  1 H�q�p�o o�n v�m }�l�k�j�i�h�g ��f�e�d�c ��b�q 
�p 0 x  �o 0 x3  �n 0 hellostring helloString�m 0 spacestring spaceString�l 0 worldstring worldString�k 0 
helloworld  
�j .sysottosnull���     TEXT�i d
�h 
TEXT�g  0 numbertostring numberToString
�f 
nmbr�e  0 stringtonumber stringToNumber
�d 
leng�c 0 stringlenght stringLenght
�b .sysodlogaskr        TEXT�s V� hUO� hUO�E�O�m$E�O�E�O�E�O�E�O��%�%E�O�j O��&E�Oa a &E` O�a ,E` Oa j �� 
 � @�@      � � � �  h e l l o   w o r l d � � � �  1 0 0�� 
�� ��  ��  ��  ��  ��  ��   ascr  ��ޭ