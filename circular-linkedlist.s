.data
    listInput: .string "ADD(1) ~ ADD(a) ~ ADD(.) ~ ADD(0) ~ ADD(d) ~ ADD(C) ~PRINT ~ REV ~PRINT~SSX~PRINT~ SORT~ PRINT      ~SDX~PRINT~  DEL(d)~ DEL(0)~PRINT"
    start_data: .word 0x720  # pahead address
    max_operations: .word 30
    new_line: .string "\n"

.text
    la s0, listInput
    lw s2, max_operations
    li s3, 0
    
    new_op:
        lb t0, 0(s0)
        beq t0, zero, END_MAIN
        li t1, 32              # space
        beq t0, t1, next
        li t1, 65              # A
        beq t0, t1, read_A
        li t1, 80              # P
        beq t0, t1, read_P
        li t1, 83              # S
        beq t0, t1, read_S
        li t1, 68              # D
        beq t0, t1, read_D
        li t1, 82              # R
        beq t0, t1, read_R
        j error
    op_end:
        addi s3, s3, 1
        beq s3, s2, END_MAIN   # max operations
    next:
        addi s0, s0, 1
        j new_op          
    #---------------------------------------------------------------
    #----------------------      UTILITY      ----------------------
    #---------------------------------------------------------------
    error:
        li t1, 126             # ~
        beq t0, t1, next
        addi s0, s0, 1
        lb t0, 0(s0)
        beq t0, zero, END_MAIN
        j error
    #---------------------------------------------------------------
    ignore_spaces:
        addi s0, s0, 1
        lb t0, 0(s0)
        beq t0, zero, end_function        
        li t1, 126             # ~
        beq t0, t1, end_function
        li t1, 32              # space
        bne t0, t1, error
        j ignore_spaces
    #---------------------------------------------------------------   
    LAST_INDEX:  
        beq s1, zero, empty_list
        add t0, s1, zero
    cicle_lastIndex:
        add a0, t0, zero
        lw t0, 1(t0)
        beq t0, s1 end_function
        j cicle_lastIndex
    empty_list:
        add a0, zero, zero
    #---------------------------------------------------------------       
    end_function:
        jr ra  
    #---------------------------------------------------------------
    #---------------------   READ OPERATION   ----------------------
    #---------------------------------------------------------------
    read_P:
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 82              # R
        bne t0, t1, error
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 73              # I
        bne t0, t1, error
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 78              # N
        bne t0, t1, error
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 84              # T
        bne t0, t1, error
        
        jal ignore_spaces
        jal PRINT
        j op_end
        
    PRINT:
        beq s1, zero, end_function
        li a7, 11
        add t0, s1, zero
    print_cicle:
        lb a0, 0(t0)
        ecall
        lw t0, 1(t0)
        beq t0, s1, print_end
        j print_cicle
    print_end:
        li a7, 4
        la a0, new_line
        ecall
        jr ra
    #---------------------------------------------------------------
    read_A:
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 68              # D
        bne t0, t1, error
        addi s0, s0, 1
        lb t0, 0(s0)
        bne t0, t1, error      # D
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 40
        bne t0, t1, error      # open ()
        addi s0, s0, 1
        lb a1, 0(s0)           # char in a1
        li t1, 32
        blt a1, t1, error      # char is smaller than 32
        li t1, 125
        bgt a1, t1, error      # char is bigger than 125
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 41              # close ()
        bne t0, t1, error
        
        jal ignore_spaces
        jal ADD
        j op_end
               
    ADD:
        addi sp, sp, -4
        sw ra, 0(sp)
        lw t1, start_data
        jal FIND_EMPTY_SPACE
        beq s1, zero, first_element
        jal LAST_INDEX
        sw t1, 1(a0)
        j save_data
    first_element:
        add s1, t1, zero
    save_data:
        sb a1, 0(t1)
        sw s1, 1(t1)
        
        lw ra, 0(sp)
        addi sp, sp, 4       
        jr ra  

    next_empty_space:
        addi t1, t1, 5
    FIND_EMPTY_SPACE:
        lb t0, 0(t1)
        bne t0, zero, next_empty_space
        lw t0, 1(t1)
        bne t0, zero, next_empty_space
        jr ra 
   #---------------------------------------------------------------
   read_D:
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 69              # E
        bne t0, t1, error
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 76              # L
        bne t0, t1, error
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 40              # open ()
        bne t0, t1, error
        addi s0, s0, 1
        lb a1, 0(s0)
        li t1, 32
        blt a1, t1, error      # less than 32
        li t1, 125
        bgt a1, t1, error      # bigger than 125
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 41              # close ()
        bne t0, t1, error
        
        jal ignore_spaces
        jal DEL
        j op_end
        
    DEL:
        beq s1, zero, end_function
        addi sp, sp, -4
        sw ra, 0(sp)
        add t2, s1, zero
        add t1, zero, zero
    del_cicle:  
        lb t3, 0(t2)
        beq t3, a1, found
        add t1, t2, zero
        lw t2, 1(t2)
        beq t2, s1, del_ra
        j del_cicle
    found:
        lw t3, 1(t2)      
        bne t1, zero, update_before
        beq t3, s1, del_solo
        jal LAST_INDEX
        lw s1, 1(s1)                  # new head pointer
        sw s1, 1(a0)
        sb zero, 0(t2)                # delete data
        sw zero, 1(t2)                # delete data pointer
        add t2, t3, zero
        j del_cicle
    update_before:
        sw t3, 1(t1)
        j del_end
    del_solo:
        add s1, zero, zero
    del_end:
        sb zero, 0(t2)                # delete data
        sw zero, 1(t2)                # delete data pointer
        beq s1, zero, del_ra
        beq t3, s1, del_ra
        add t2, t3, zero
        j del_cicle
    del_ra: 
        lw ra, 0(sp)
        addi sp, sp, 4       
        jr ra      
    #---------------------------------------------------------------
    read_R:
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 69              # E
        bne t0, t1, error
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 86              # V
        bne t0, t1, error
        
        jal ignore_spaces
        jal REV
        j op_end
               
    REV:                       # reverse
        beq s1, zero, end_function
        lw t1, 1(s1)
        beq t1, s1, end_function
        add t0, s1, zero
        add t2, zero, zero
    rev_cicle:
        sw t2, 1(t0)
        add t2, t0, zero
        add t0, t1, zero
        beq t0, s1, rev_end
        lw t1, 1(t0)
        j rev_cicle
    rev_end:
        sw t2, 1(s1)
        add s1, t2, zero
        jr ra       
    #---------------------------------------------------------------
    read_ssx:
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 88              # X
        bne t0, t1, error
        
        jal ignore_spaces
        jal SSX
        j op_end   
    
    SSX:                       # left shift
        beq s1, zero, end_function
        lw s1, 1(s1)
        jr ra
    #---------------------------------------------------------------
    read_sdx:
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 88              # X
        bne t0, t1, error
        
        jal ignore_spaces
        jal SDX
        j op_end 
    
    SDX:                       # right shift
        beq s1, zero, end_function
        addi sp, sp, -4
        sw ra, 0(sp)
        jal LAST_INDEX
        add s1, a0, zero
        lw ra, 0(sp)
        addi sp, sp, 4       
        jr ra            
    #---------------------------------------------------------------
    read_S:
        addi s0, s0, 1
        lb t0, 0(s0)        
        beq t0, t1, read_ssx     # S
        li t1, 68                # D
        beq t0, t1, read_sdx

        li t1, 79                # O
        bne t0, t1, error
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 82                # R
        bne t0, t1, error
        addi s0, s0, 1
        lb t0, 0(s0)
        li t1, 84                # T
        bne t0, t1, error
        
        jal ignore_spaces
        jal SORT
        j op_end
    
    # QUICKSORT pivot last element
    SORT:
        beq s1, zero, end_function
        addi sp, sp, -4
        sw ra, 0(sp)
        add a2, s1, zero
        jal LAST_INDEX
        jal QUICKSORT
        lw ra, 0(sp)
        addi sp, sp, 4       
        jr ra  
        
    QUICKSORT:        
        beq a2, zero, end_function
        beq a2, a0, end_function
        addi sp, sp, -8
        sw ra, 4(sp)
        sw a0, 0(sp)     
        jal PARTITION
        beq a4, zero, solo_sx
        add a0, a4, zero
        jal QUICKSORT
    solo_sx:
        lw a0, 0(sp)
        addi sp, sp, 4
        bne a4, zero, pivot_notfirst
        lw a2, 1(a2)
        jal QUICKSORT
        j quick_end
    pivot_notfirst:
        lw a2, 1(a4)
        beq a2, a0, quick_end
        lw a2, 1(a2)
        jal QUICKSORT
    quick_end:
        lw ra, 0(sp)
        addi sp, sp, 4       
        jr ra  
    
    PARTITION:
        addi sp, sp, -8
        sw a2, 0(sp)
        sw ra, 4(sp)            
        add a4, a2, zero
        add t0, a2, zero
        lb t1, 0(a0)
        add a1, t1, zero       # pivot
        jal find_group
        add t4, a1, zero
    part_cicle:
        beq a2, a0, part_end
        lb t2, 0(a2)
        add a1, t2, zero
        jal find_group
        add t5, a1, zero
        bne t4, t5, different_groups
        bgt t2, t1, part_else
    different_groups: 
        bgt t5, t4, part_else
        add a4, t0, zero
        lb t3, 0(t0)
        sb t2, 0(t0)
        sb t3, 0(a2)
        lw t0, 1(t0)
    part_else:
        lw a2, 1(a2)
        j part_cicle
    part_end:
        lb t2, 0(t0)
        sb t1, 0(t0)
        sb t2, 0(a0)
        lw a2, 0(sp)
        lw ra, 4(sp)
        addi sp, sp, 8
        bne t0, a2, end_function
        add a4, zero, zero
        jr ra
        
    find_group:
        li t5, 48
        blt a1, t5, extra      # extra < 48
        li t5, 58
        blt a1, t5, num_min    # 48 <= 1-9 < 58
        li t5, 65
        blt a1, t5, extra      # 58 <= extra < 65
        li t5, 91
        blt a1, t5, maiusc     # 65 <= A-Z < 91
        li t5, 97
        blt a1, t5, extra      # 91 <= extra < 97
        li t5, 123
        blt a1, t5, num_min    # 97 <= a-z < 123
        j extra                # 123 <= extra
    extra:
        li a1, 0
        jr ra
    num_min:
        li a1, 1
        jr ra
    maiusc:
        li a1, 2
        jr ra
    #---------------------------------------------------------------
    END_MAIN:
        add a0, a0, zero
    
    
    


