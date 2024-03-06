section .data
	; declare global vars here

section .text
	extern printf
	global reverse_vowels

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place
reverse_vowels:
	push ebp
	push esp
	pop ebp
	push ebx

	; punem in ebx valoarea -1
	push -1
	pop ebx

	; punem in eax parametrul (char *string)
	push DWORD [ebp + 8]
	pop eax 

	; se verifica daca caracterele sunt vocale
	; daca sunt se sare la push_vowel
	test_characters:
	inc ebx
	cmp BYTE [eax + ebx], 'a'
	je push_vowel
	cmp BYTE [eax + ebx], 'e'
	je push_vowel
	cmp BYTE [eax + ebx], 'i'
	je push_vowel
	cmp BYTE [eax + ebx], 'o'
	je push_vowel
	cmp BYTE [eax + ebx], 'u'
	je push_vowel
	jmp end_test

	; se da push pe stiva la vocale
	push_vowel:
		push DWORD [eax + ebx]
	end_test:
	cmp BYTE [eax + ebx], 0
	jne test_characters


	; punem in ebx valoarea -1
	push -1
	pop ebx

	; acum, de fiecare data cand dam de o vocala 
	; o inlocuim cu ultima vocala aflata pe stiva, astfel
	; se inverseaza oridinea vocalelor din propozitii
	insert_characters:
	inc ebx
	cmp BYTE [eax + ebx], 'a'
	je pop_vowel
	cmp BYTE [eax + ebx], 'e'
	je pop_vowel
	cmp BYTE [eax + ebx], 'i'
	je pop_vowel
	cmp BYTE [eax + ebx], 'o'
	je pop_vowel
	cmp BYTE [eax + ebx], 'u'
	je pop_vowel
	jmp end_ins
	; efectiv, pop la vocala si introducere in locul celei vechi
	pop_vowel:
		push dword [eax + ebx] 
		pop edx
		xor byte [eax + ebx], dl

		pop ecx
		or byte [eax + ebx], cl
	end_ins:
	cmp BYTE [eax + ebx], 0
	jne insert_characters
	
	pop ebx
	pop ebp
	ret