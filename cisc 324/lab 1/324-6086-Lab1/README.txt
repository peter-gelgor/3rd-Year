1)
    1) The program will return incorrect computations, as the child is never sending it's results to the parent to be added,
        so the program will only return the summation of the first half

    2) I fixed the issue, by having the parent process wait for the child process to finish, and then once the child has finished,
	    I have it exit with it's exit status being the total that it computed. I then have the parent process compute it's total, and
        at the end, I simply add the exit status of the child program (it's computed total) to the parents total using the WEXITSTATUS macro.

    3) The value of n in this case is 26. The reason for this, is because WEXITSTATUS only retrieves the lowest byte of the status. One byte can
        only hold up to 255, and the partial summation of 26 starting from 14 is 260, which is greater then 255, so therefore the parent will recieve an incomplete value 
        from the child.

    4) By making the child compute the first half of the calculations rather then the second half, it's numbers will be smaller allowing for a higher value of n.
        Due to the fact that we are only allowed to go up to 255, the largest value with this sum is 22, meaning that our value for n is 23 * 2, or 46.

2)
    1) The reason that the value stored in nums.txt never reaches 15000 (or even much higher then 5000) is because
        each child process is starting at roughly the same time, and because the value starts at 0, they're all writing roughly the 
        same thing each time. Because the file gets rewritten every increment of the for loop, the last child is seeing it after the first few
        have already written to it a few times, which is why it's usually a little bit higher then 5000

    2) The lower bound would be 2. A possible scenario for that would be as follows:
        All processes start, and read the value 0 from the file.
        The first process executes 5000 times without being interupted. 
        The second process then executes 4999 times and then gets interupted. After having read the
            first number as 0, this means that the number in the file will be 4999 rather then 9999.
        The third process then completes it's first round and writes 1 to the file, as it originally read 0 from the file.
        The second process then begins it's final pass, and reads the number 1 from the file.
        The third process then runs to completion.
        The second process then writes 2 to the file as it previously read 1 from the file from the first time the third process
            wrote to the file.

    3) To fix the issue, what I did was I had each process run sequentially rather then at the same time. To do that,
        I simply waited for each process to finish by using the wait() function before having the parent create a new one.