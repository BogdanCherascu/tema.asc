.section .note.GNU-stack,"",@progbits

.data
    numarOperatii:           .space 4                 
    indOp:                   .space 4                 
    opAdd:                   .space 4                 
    descriptor:              .space 4
    dimensiune:              .space 4
    formatRead:              .asciz "%d"
    formatPrint_1:           .asciz "%d: (%d, %d)\n"  
    formatPrint_2:           .asciz "(%d, %d)\n"
    formatPrint_endline:     .asciz "\n"
    formatPrintVerif:        .asciz "%d \n"
    i:                       .space 4
    j:                       .space 4
    idx:                     .space 4
    memorie:                 .space 4096
    blocuriNecesare:         .space 4
    pozInit:                 .long 0
    pozFin:                  .long 0
    valoareMemorie:          .long 1025
    randVar:                 .space 4

.text

    proc_ADD:
        pushl %ebx
        pushl %edi
        pushl %ebp
        movl %esp, %ebp

        pushl $descriptor
        pushl $formatRead
        call scanf
        popl %edx
        popl %edx

        pushl $dimensiune
        pushl $formatRead
        call scanf
        popl %edx
        popl %edx

        movl $0, %edx
        movl dimensiune, %eax
        movl $8, %ebx
        divl %ebx
        cmpl $0, %edx

        je salt_increment

        addl $1, %eax

        salt_increment:
            cmpl valoareMemorie, %eax
            jg limita_atinsa_add

            movl %eax, %ebx
            movl $0, %ecx
            leal memorie, %edi

        for_cautaLiber:
            cmpl valoareMemorie, %ecx
            jg limita_atinsa_add

            movl %ecx, j
            movl %ebx, %eax
            addl %ecx, %eax

            cmpl valoareMemorie, %eax
            je limita_atinsa_add

            movl $0, %esi

        verif_liber:
            movl (%edi, %ecx, 4), %eax
            cmpl $0, %eax
            jne creste_cont

            addl $1, %ecx
            addl $1, %esi
            cmpl %ebx, %esi
            je gasit_Liber

            jmp verif_liber

        gasit_Liber:
            movl j, %ecx
            movl %ebx, %eax

        alocare_blocuri:
            cmpl $0, %eax
            je valori_pozitii

            movl descriptor, %ebx
            movl %ebx, (%edi, %ecx, 4)
            addl $1, %ecx
            subl $1, %eax

            jmp alocare_blocuri

        creste_cont:
            addl $1, %ecx
            jmp for_cautaLiber

        valori_pozitii:
            movl j, %ebx
            movl %ebx, pozInit
            movl %ecx, pozFin
            subl $1, pozFin

            jmp sfarsit_Add

        limita_atinsa_add:
            movl $0, %ecx
            movl %ecx, pozInit
            movl %ecx, pozFin
            
        sfarsit_Add:
            popl %ebp
            popl %edi
            popl %ebx
            ret


    proc_GET:
        pushl %ebx
        pushl %edi
        pushl %ebp
        movl %esp, %ebp

        pushl $descriptor
        pushl $formatRead
        call scanf
        popl %edx
        popl %edx
        
        leal memorie, %edi
        movl $0, %ecx

        for_cautaID:
            movl (%edi, %ecx, 4), %eax
            cmpl descriptor, %eax
            je gasitID

            cmpl valoareMemorie, %ecx
            je limita_atinsa_get

            addl $1, %ecx
            jmp for_cautaID
        
        gasitID:
            movl %ecx, pozInit

            limita_superioara:
                cmpl descriptor, %eax
                jne gasit_limita

                addl $1, %ecx
                movl (%edi, %ecx, 4), %eax
                jmp limita_superioara
        
        gasit_limita:
            movl %ecx, pozFin
            subl $1, pozFin
            jmp sfarsit_Get


        limita_atinsa_get:
            movl $0, %ecx
            movl %ecx, pozFin
            movl %ecx, pozInit 

        sfarsit_Get:
            popl %ebp
            popl %edi
            popl %ebx
            ret

    proc_DELETE:
        pushl %ebx
        pushl %edi
        pushl %ebp
        movl %esp, %ebp

        pushl $descriptor
        pushl $formatRead
        call scanf
        popl %edx
        popl %edx

        leal memorie, %edi
        movl $0, %ecx
        
        for_cautaStergere:
            movl (%edi, %ecx, 4), %eax
            cmpl %eax, descriptor
            je gasitStergere

            cmpl %ecx, valoareMemorie
            je sfarsit_Delete

            addl $1, %ecx
            jmp for_cautaStergere


        gasitStergere:
            cmpl %eax, descriptor
            jne sfarsit_Delete

            movl $0, (%edi, %ecx, 4)
            addl $1, %ecx
            movl (%edi, %ecx, 4), %eax

            jmp gasitStergere

        sfarsit_Delete:
            call proc_afisareStiva
            popl %ebp
            popl %edi
            popl %ebx
            ret

    proc_afisareStiva:
        pushl %ebx
        pushl %edi
        pushl %ebp
        movl %esp, %ebp

        movl $0, %ecx
        #leal memorie, %edi
        movl (%edi, %ecx, 4), %eax

        for_verif:
            
            cmpl %ecx, valoareMemorie
            je sfarsit_afisareStiva

            cmpl $0, %eax 
            je salt

            movl %ecx, pozInit
            movl %eax, %ebx

        for_intervale:
            cmpl %ecx, valoareMemorie
            je for_afisare

            cmpl %eax, %ebx
            jne for_afisare

            addl $1, %ecx
            movl (%edi, %ecx, 4), %eax
            jmp for_intervale

        for_afisare:
            subl $1, %ecx
            movl %ecx, pozFin

            pushl %edi
            pushl %eax
            pushl %ecx

            pushl pozFin
            pushl pozInit
            pushl %ebx
            pushl $formatPrint_1
            call printf
            popl %edx
            popl %edx
            popl %edx
            popl %edx

            popl %ecx
            popl %eax
            popl %edi
        salt:
            addl $1, %ecx
            movl (%edi, %ecx, 4), %eax
            jmp for_verif


        sfarsit_afisareStiva:
            popl %ebp
            popl %edi
            popl %ebx
            ret
        
    proc_DEFRAGMENTATION:
        pushl %ebx
        pushl %edi
        pushl %ebp
        movl %esp, %ebp

        movl $0, %ecx
        movl $0, %edx
        leal memorie, %edi

        for_defrag:
            movl (%edi, %ecx, 4), %eax
            cmpl valoareMemorie, %ecx
            je sfarsit_Defragmentation

            cmpl $0, %eax
            jg transfer

            jmp cont_for
        
        transfer:
            movl %eax, (%edi, %edx, 4)
            cmpl %ecx, %edx
            je salt_0
            movl $0, (%edi, %ecx, 4)

        salt_0:
            addl $1, %edx
            jmp cont_for

        cont_for:
            addl $1, %ecx
            jmp for_defrag

        sfarsit_Defragmentation:
            call proc_afisareStiva    
            popl %ebp
            popl %edi
            popl %ebx
            ret


.global main

    main:

    pushl $numarOperatii
    pushl $formatRead
    call scanf
    popl %ebx
    popl %ebx
    
    movl $0, %eax
    movl %eax, i
    movl %eax, j

    for_operatii:
        movl i, %ecx
        cmpl %ecx, numarOperatii
        je etexit

        pushl $indOp
        pushl $formatRead
        call scanf
        popl %ebx
        popl %ebx

        movl indOp, %eax

        cmpl $1, %eax
        je operatieAdd

        cmpl $2, %eax
        je operatieGet

        cmpl $3, %eax
        je operatieDelete

        cmpl $4, %eax
        je operatieDefragmentare

        cmpl $5, %eax
        jge etexit

        sfarsit_for_operatii:
        
            movl i, %ebx
            addl $1, %ebx
            movl %ebx, i

        jmp for_operatii
    
    operatieAdd:
        pushl $opAdd
        pushl $formatRead
        call scanf
        popl %ebx
        popl %ebx

        movl $0, j
        movl $0, %ecx
        for_Add:
            movl opAdd, %ebx
            cmpl %ecx, %ebx
            je sfarsit_for_operatii

            pushl %ecx
            call proc_ADD
            popl %ecx

            movl pozFin, %eax
            addl $1, %eax
            movl %eax, j
            
            pushl %ecx

            pushl pozFin
            pushl pozInit
            pushl descriptor
            pushl $formatPrint_1
            call printf
            popl %edx
            popl %edx
            popl %edx
            popl %edx
            
            popl %ecx

            addl $1, %ecx
            jmp for_Add
    operatieGet:
        pushl %ecx
        call proc_GET
        popl %ecx

        pushl %ecx
        pushl pozFin
        pushl pozInit
        pushl $formatPrint_2
        call printf
        popl %edx
        popl %edx
        popl %edx
        popl %ecx

        jmp sfarsit_for_operatii

    operatieDelete:
        pushl %ecx
        call proc_DELETE
        popl %ecx

        jmp sfarsit_for_operatii

    operatieDefragmentare:
        pushl %ecx
        call proc_DEFRAGMENTATION
        popl %ecx

        jmp sfarsit_for_operatii       

    etexit:

        pushl $0
        call fflush
        popl %eax

        movl $1, %eax
        movl $0, %ebx
        int $0x80



