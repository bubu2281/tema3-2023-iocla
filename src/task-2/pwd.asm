section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	home db "home", 0


	text    db      "mere!!!", 10, 0
	strformat db    "%s\n", 0
	; declare global vars here

section .text
	global pwd
	extern strcmp
	extern strcat
	extern strcpy
	extern printf
	extern strrev

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories
pwd:
	enter 0, 0
	pusha

	mov esi, [ebp + 8] ; **directories
	mov ecx, [ebp + 12]; n
	mov edx, [ebp + 16]; *output

	; in edi retinem cate foldere trebuie ignorate
	mov edi, 0

	
	for:

	;verificam elementul este ".."
	; daca este, tinem minte ca trebuie sa sarim peste un folder
	; implementarea citeste de la coada la cap
	pusha
	push back
	push dword [esi + (ecx - 1)*4]
	call strcmp
	add esp, 8
	cmp eax, 0
	je back_label
	popa
	

	; daca elementul este "." atunci se trece mai departe fara a se va face
	; nimic
	pusha
	push dword [esi + (ecx - 1)*4]
	push curr
	call strcmp
	add esp, 8
	cmp eax, 0
	je curr_label
	popa

	; daca edi != 0 atunci ignoram folderul curent
	cmp edi, 0 
	jne ignore_label


    ; daca nu, introducem in path folderul respectiv,
	;  mai exact il introducem in fata
	; ce am scris mai jos se trasnpune astfel in c
	; 
	; strcat(folder,"/");
	; strcat(folder, path);
	; strcpy(path, folder);
	; 
	; 
	pusha
	push slash
	push dword [esi + (ecx - 1)*4]
	call strcat
	add esp, 8
	popa


	pusha
	push edx
	push dword [esi + (ecx - 1)*4]
	call strcat
	add esp, 8
	popa


	pusha
	push dword [esi + (ecx - 1)*4]
	push edx
	call strcpy
	add esp, 8
	popa

	jmp end_for
	; daca intalnim ".." incrementam edi
	; pentru a sti ca trb sa ignoram un anumit nr de foldere
	back_label:
		popa
		inc edi
		jmp end_for
	curr_label:
		popa
		jmp end_for

	; daca am ignorat un folder, scadem edi
	ignore_label:
		dec edi
		jmp end_for
	end_for:
	loop for
	

	; in final, pathul nostru o sa fie complet doar ca o sa lipseasca,
	; din el la inceput caracterul "/", asa ca ne folosiim de home ca un
	; aux si ca mai sus adaugam in fata stringului caract "/"
	pusha
	push edx
	push home
	call strcpy
	add esp, 8
	popa

	pusha
	push slash
	push edx
	call strcpy
	add esp, 8
	popa

	pusha
	push home
	push edx
	call strcat
	add esp, 8
	popa

	popa
	leave
	ret