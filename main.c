#include <stdio.h>
#include <pthread.h>
#include <stdatomic.h>

// Shared Memory Counter 
int shared_counter = 0;

// Memory Address Lock 
// 0: Unlocked , 1: Locked 
atomic_int hardware_lock = 0; 

/* ========================================================================
   GOLDEN MODEL: Custom Execution Unit 
   ======================================================================== */
int custom_test_and_set(atomic_int *lock_addr) {

    return atomic_exchange(lock_addr, 1);
}

void* process_function(void* arg) {
    int thread_id = *((int*)arg);

    for(int i = 0; i < 1000000; i++) {

        while (custom_test_and_set(&hardware_lock) == 1) {
            // Locked, wait until it's unlocked
        }

        // Race condition is prevented here because only one thread can access this section at a time.
        shared_counter++;

        // Unlock the hardware lock
        hardware_lock = 0;
    }
    
    printf("Thread %d \'s process is completed.\n", thread_id);
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;

    printf("Two threads are trying to increment the counter %d times simultaneously...\n", 1000000);

    // Create two threads
    pthread_create(&thread1, NULL, process_function, &id1);
    pthread_create(&thread2, NULL, process_function, &id2);

    // Wait for both threads to finish
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    // Expected result: 1.000.000 + 1.000.000 = 2.000.000
    printf("Expected Counter Value: 2000000\n");
    printf("Actual Counter Value: %d\n", shared_counter);

    if (shared_counter == 2000000) {
        printf("RESULT: Atomic Instruction simulation SUCCESSFUL! Race Condition prevented.\n");
    } else {
        printf("RESULT: FAILURE! Race Condition occurred.\n");
    }

    return 0;
}