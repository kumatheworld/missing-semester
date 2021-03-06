# missing-semester
My exercise solutions to [The Missing Semester of Your CS Education, Winter 2020](https://missing.csail.mit.edu/2020/) from MIT.

<details>
<summary>Course overview + the shell</summary>

1. ``` sh
   $ echo $SHELL
   /bin/bash
   ```
2. ``` sh
   $ mkdir /tmp/missing
   ```
3. ``` sh
   $ man touch
   ```
4. ``` sh
   $ touch /tmp/missing/semester
   ```
5. ``` sh
   $ echo '#!/bin/sh' > /tmp/missing/semester
   $ echo 'curl --head --silent https://missing.csail.mit.edu' >> /tmp/missing/semester
   ```
6. ``` sh
   $ /tmp/missing/semester
   -bash: /tmp/missing/semester: Permission denied
   $ ls -l /tmp/missing/semester
   -rw-r--r--  1 kumatheworld  wheel  61 Jun 30 19:20 /tmp/missing/semester
   ```
7. This works because it only needs the read permission unlike the previous one that needs the execute permission.
   ``` sh
   $ sh /tmp/missing/semester
   HTTP/2 200
   server: GitHub.com
   content-type: text/html; charset=utf-8
   last-modified: Sat, 26 Jun 2021 10:14:39 GMT
   access-control-allow-origin: *
   etag: "60d6fe0f-1f31"
   expires: Sat, 26 Jun 2021 18:02:11 GMT
   cache-control: max-age=600
   x-proxy-cache: MISS
   x-github-request-id: E25A:3CCC:1CEDC6:1F2376:60D7694B
   accept-ranges: bytes
   date: Wed, 30 Jun 2021 10:29:43 GMT
   via: 1.1 varnish
   age: 385
   x-served-by: cache-hnd18744-HND
   x-cache: HIT
   x-cache-hits: 1
   x-timer: S1625048984.682678,VS0,VE1
   vary: Accept-Encoding
   x-fastly-request-id: af16a01b69ff7c7a566e819ede35ff74bfc59970
   content-length: 7985
   ```
8. ``` sh
   $ man chmod
   ```
9. The first line of `/tmp/missing/semester` right after the shebang `#!` tells the shell what program to run. In our case, that is `/bin/sh`.
   ``` sh
   $ chmod u+x /tmp/missing/semester
   $ /tmp/missing/semester
   (command output shown)
   ```
0. ``` sh
   $ /tmp/missing/semester | grep "last-modified" > ~/last-modified.txt
   ```
</details>

<details>
<summary>Shell Tools and Scripting</summary>

1. The following command lists the files under `$dir` in that way.
   ``` sh
   $ ls -alhtG "$dir"
   ```
2. ``` sh
   marco() {
      export MARCO=$(pwd)
   }

   polo() {
      cd "$MARCO"
   }
   ```
3. Assuming the given script is named `magic.sh`, the following script is what we want.
   ``` sh
   #!/usr/bin/env bash

   file=output.txt
   > $file
   while [ $? -eq 0 ]; do
      ./magic.sh >> $file 2>&1
   done

   cat $file
   n=$(wc -l < $file | sed 's/ //g' | xargs -I{} expr {} - 1)
   echo "It took $n runs to fail"
   ```
4. On MacOS, the following command creates `htmls.zip` that has all `.html` files under `$dir` or its subdirectories.
   ``` sh
   $ find "$dir" -name "*.html" -print0 | xargs -0 zip htmls.zip
   ```
5. On MacOS, the following command lists all files under `$dir` or its subdirectories by recency. To get the most recently changed file only, pipe it to `head -n1`.
   ``` sh
   $ find "$dir" -type f -print0 | xargs -0 ls -lt
   ```
</details>

<details>
<summary>Editors (Vim)</summary>

1. Done.
2. Done.
3. Done.
4. Done.
5. Ok I will try.
6. Skipped for now.
7. Skipped for now.
8. I followed the [macros](https://missing.csail.mit.edu/2020/editors/#macros) section and got [example-data.json](example-data.json). Note that you have to undo the changes made by the intermediate macros `e` and `p`.
</details>

<details>
<summary>Data Wrangling</summary>

1. Done.
2. Look at the following command.
   ``` sh
   $ grep -i "a.*a.*a" /usr/share/dict/words | rev | cut -c-2 | rev | sort | uniq -c
   ```
   The `grep` part finds the words that have 3 `a`'s in the case insensitive manner. Note that we do not check if each word ends with `'s` as no word in the file does. What the `rev | cut -c-2 | rev` part does is get the last 2 characters from each word. Finally, by `sort | uniq -c` we get a list of suffixes with multiplicity.

   By further piping the output to `sort | tail -1` we get the most common suffix `al`, which appears 1,039 times. We can use `wc -l` instead to get the number of suffixes, which is 156. Looking at the output of the command above, which is sorted alphabetically, we can easily find a suffix that does not show up. For example, `ab` as in `tab` is not listed there.
3. Running `sed s/REGEX/SUBSTITUTION/ input.txt > input.txt` will clear `input.txt` as the shell first tries to create a new file `input.txt` to get ready for the redirection. We can run `sed -i s/REGEX/SUBSTITUTION/ input.txt` to get around this.
4. I skip this as it turned out there was little information from the log.
   ``` sh
   $ log show | grep -e"=== system boot:" -e"Previous shutdown cause" | cut -d' ' -f-2
   2021-07-06 20:25:13.000000+0900
   2021-07-21 19:06:06.000000+0900
   2021-07-21 19:06:06.736536+0900
   ```
5. The following command almost does the job.
   ``` sh
   $ log show --process 0 | cut -c89- | sort | uniq -c | awk '$1 == 1' | tr -s ' ' | cut -c4-
   ```
   Note that we do not filter out old information from earlier than the past 3 reboots since we do not have it in the first place.

   This command has some more problems that I am not sure how to fix. Firstly, it might possibly filter out messages that show up multiple times in a reboot and do not in other reboots. Another serious problem is that the command output is too long to see in practice, being well over 100k lines. This is because it contains many lines that are basically the same but slightly different in number.
6. The following command downloads the table from the [first website](https://ucr.fbi.gov/crime-in-the-u.s/2016/crime-in-the-u.s.-2016/topic-pages/tables/table-1) and shows the statistics of the population column.
   ``` sh
   $ curl -s https://ucr.fbi.gov/crime-in-the-u.s/2016/crime-in-the-u.s.-2016/tables/table-1 | tr '\n' '\a' | grep -o '<table.*</table>' | tr '\a' '\n' | grep -A1 'headers="cell31 ' | grep "</td>" | sed 's/[^0-9]//g' | R --slave -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
   Min.   1st Qu.    Median      Mean   3rd Qu.      Max.
   267783607 287309833 300509820 298634769 312159283 323127513
   ```
   To get the statistics of the n-th column in general, change `'headers="cell31 '` to `'headers="cell3{n} '` (removing the curly braces).
</details>

<details>
<summary>Command-line Environment</summary>

#### Job control
1. ``` sh
   $ sleep 10000
   ^Z
   [1]+  Stopped                 sleep 10000
   $ bg
   [1]+ sleep 10000 &
   $ pgrep -af "sleep 10000"
   12443
   $ pkill -af "sleep 10000"
   [1]+  Terminated: 15          sleep 10000
   ```
2. Using `wait`:
   ``` sh
   $ sleep 60 &
   [1] 12651
   $ wait %1; ls
   [1]+  Done                    sleep 60
   README.md         example-data.json
   ```
   Defining `pidwait`:
   ``` sh
   pidwait() {
      :
      while [ $? -eq 0 ]; do
         sleep 1
         kill -0 $1 2>/dev/null
      done
      ls
   }
   ```
   ``` sh
   $ sleep 10 &
   [1] 15304
   $ pidwait $(pgrep -af "sleep 10")
   [1]+  Done                    sleep 10
   README.md         example-data.json
   ```
#### Terminal multiplexer
1. Done.
#### Aliases
1. ``` sh
   alias dc=cd
   ```
2. Below is the command output. As you can see, nothing is really worth setting an alias for. Doing something like `alias gc="git commit"` might help but I am willing to type the full commands for those.
   ``` sh
   $ history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10
   1 07/27/21 22:00:42 tmjux
   1 07/27/21 22:00:43 tmux
   1 07/27/21 22:00:50 screen
   1 07/27/21 22:03:30 tmux
   1 07/27/21 22:06:41 tmux ls
   1 07/27/21 22:37:09 nano diary.md
   1 07/27/21 22:38:53 git commit -am "Add 2021-07-27"
   1 07/27/21 22:38:55 git push
   1 07/28/21 08:03:35 brew install --cask virtualbox
   1 07/28/21 19:43:04 history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10   ```
#### Dotfiles
1. Done.
2. Done.
3. Done.
4. Done.
5. Skipped for now. I will add things like `.bashrc` later.
6. See https://github.com/kumatheworld/dotfiles.
#### Remote Machines
1. Done.
2. Done.
3. Done.
4. Done.
5. I replaced the existing lines with the following.
   ``` sh
   PermitRootLogin no
   PasswordAuthentication no
   ```
6. Below are the commands I hit to make sure that mosh can properly recover from a disconnection of the network adapter of the server.

   VM:
   ``` sh
   $ mosh-server
   MOSH CONNECT 60003 q1L6MiTKHPtwZtFY4WnT7A

   mosh-server (mosh 1.3.2) [build mosh 1.3.2]
   Copyright 2012 Keith Winstein <mosh-devel@mit.edu>
   License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
   This is free software: you are free to change and redistribute it.
   There is NO WARRANTY, to the extent permitted by law.

   [mosh-server detached, pid = 14085]
   $ sudo ip link set enp0s3 down
   $ sudo ip link set enp0s3 up
   ```
   Local (ssh):
   ```sh
   $ ssh vm
   $ client_loop: send disconnect: Broken pipe
   ```
   Local (mosh):
   ```sh
   $ mosh vm
   ```
   The ssh/mosh connections were made after executing `mosh-server` on the VM. After `sudo ip link set enp0s3 down`, I waited for about a minute to see the `client_loop: send disconnect: Broken pipe` message from the ssh connection. The ssh connection was lost but the mosh connection was kept throughout the experiment.
7. ``` sh
   ssh -fN vm
   ```
</details>

<details>
<summary>Version Control (Git)</summary>

1. Yes, I have some experience with Git.
2. ```sh
   $ git clone https://github.com/missing-semester/missing-semester.git
   Cloning into 'missing-semester'...
   remote: Enumerating objects: 2020, done.
   remote: Counting objects: 100% (122/122), done.
   remote: Compressing objects: 100% (71/71), done.
   remote: Total 2020 (delta 59), reused 91 (delta 44), pack-reused 1898
   Receiving objects: 100% (2020/2020), 15.60 MiB | 5.97 MiB/s, done.
   Resolving deltas: 100% (1185/1185), done.
   ```
   1.
   ```sh
   $ git log --oneline --graph
   *   602282f (HEAD -> master, origin/master, origin/HEAD) Merge branch 'LemurP/master'
   |\
   | * 154aa87 Add link to Git alias section in exercise
   |/
   * 4dfc254 Bump dependencies
   * 8010724 Separate build and links status
   *   9c84071 Merge branch 'nullmight/fix-key-type'
   |\
   | * b63aa80 Fix key type in tutorial
   |/
   *   7623daf Merge branch 'FabienRoger/add-plural'
   |\
   | * c741a74 Add plural to parent variable
   |/
   * 7ec9677 Update broken links
   * e6ab30e Use Vimium description from the GitHub repo
   ...
   ```
   2.
   ```sh
   $ git log --pretty=format:%an -n1 README.md
   Anish Athalye
   ```
   3.
   ```sh
   $ git blame _config.yml | grep collections:
   a88b4eac (Anish Athalye 2020-01-17 15:26:30 -0500 18) collections:
   $ git log --format=%B -n1 a88b4eac
   Redo lectures as a collection

   ```
3. Working in this very repository, I tried adding `id_rsa` from `~/.ssh/`, commiting and removing it and ran the BFG Repo-Cleaner.
   ```sh
   $ cp ~/.ssh/id_rsa .
   $ git add id_rsa
   $ git commit -m "Add id_rsa"
   [main 6a8d643] Add id_rsa
    1 file changed, 30 insertions(+)
    create mode 100644 id_rsa
   $ bfg --delete-files id_rsa

   Using repo : /Users/kumatheworld/Documents/GitHub/missing-semester/.git

   Found 4 objects to protect
   Found 4 commit-pointing refs : HEAD, refs/heads/main, refs/remotes/origin/HEAD, refs/remotes/origin/main

   Protected commits
   -----------------

   These are your protected commits, and so their contents will NOT be altered:

   * commit 6a8d6434 (protected by 'HEAD') - contains 1 dirty file :
         - id_rsa (1.7 KB)

   WARNING: The dirty content above may be removed from other commits, but as
   the *protected* commits still use it, it will STILL exist in your repository.

   Details of protected dirty content have been recorded here :

   /Users/kumatheworld/Documents/GitHub/missing-semester.bfg-report/2021-08-07/17-43-22/protected-dirt/

   If you *really* want this content gone, make a manual commit that removes it,
   and then run the BFG on a fresh copy of your repo.


   Cleaning
   --------

   Found 71 commits
   Cleaning commits:       100% (71/71)
   Cleaning commits completed in 200 ms.

   BFG aborting: No refs to update - no dirty commits found??

   $ git rm id_rsa
   rm 'id_rsa'
   $ git commit -m "Remove id_rsa"
   [main edb26e2] Remove id_rsa
    1 file changed, 30 deletions(-)
    delete mode 100644 id_rsa
   $ bfg --delete-files id_rsa

   Using repo : /Users/kumatheworld/Documents/GitHub/missing-semester/.git

   Found 3 objects to protect
   Found 4 commit-pointing refs : HEAD, refs/heads/main, refs/remotes/origin/HEAD, refs/remotes/origin/main

   Protected commits
   -----------------

   These are your protected commits, and so their contents will NOT be altered:

   * commit edb26e25 (protected by 'HEAD')

   Cleaning
   --------

   Found 72 commits
   Cleaning commits:       100% (72/72)
   Cleaning commits completed in 181 ms.

   Updating 1 Ref
   --------------

         Ref               Before     After
         -------------------------------------
         refs/heads/main | edb26e25 | 41fdadda

   Updating references:    100% (1/1)
   ...Ref update completed in 51 ms.

   Commit Tree-Dirt History
   ------------------------

         Earliest                                              Latest
         |                                                          |
         ..........................................................Dm

         D = dirty commits (file tree fixed)
         m = modified commits (commit message or parents changed)
         . = clean commits (no changes to file tree)

                                 Before     After
         -------------------------------------------
         First modified commit | 6a8d6434 | 1829b96f
         Last dirty commit     | 6a8d6434 | 1829b96f

   Deleted files
   -------------

         Filename   Git id
         ----------------------------
         id_rsa   | df139b64 (1.7 KB)


   In total, 3 object ids were changed. Full details are logged here:

         /Users/kumatheworld/Documents/GitHub/missing-semester.bfg-report/2021-08-07/17-54-49

   BFG run is complete! When ready, run: git reflog expire --expire=now --all && git gc --prune=now --aggressive
   $ git reflog expire --expire=now --all && git gc --prune=now --aggressive
   Enumerating objects: 212, done.
   Counting objects: 100% (212/212), done.
   Delta compression using up to 4 threads
   Compressing objects: 100% (182/182), done.
   Writing objects: 100% (212/212), done.
   Total 212 (delta 70), reused 2 (delta 0), pack-reused 0
   ```
   However, when the dirty files show up only in the latest commit like in this example, you might rather want to do `git commit --amend` to delete the files before even they become part of the history.
4. Working in this repository again, we have the following.
   ```sh
   $ echo aaa >> README.md
   $ git stash
   Saved working directory and index state WIP on main: ac21a61 6.3 done
   $ git log --all --oneline -n3
   1f3ac11 (refs/stash) WIP on main: ac21a61 6.3 done
   e7d9dba index on main: ac21a61 6.3 done
   ac21a61 (HEAD -> main, origin/main, origin/HEAD) 6.3 done
   $ git stash pop
   On branch main
   Your branch is up to date with 'origin/main'.

   Changes not staged for commit:
   (use "git add <file>..." to update what will be committed)
   (use "git restore <file>..." to discard changes in working directory)
         modified:   README.md

   no changes added to commit (use "git add" and/or "git commit -a")
   Dropped refs/stash@{0} (1f3ac112937b30ce4615fa12fdfeb4b3e2e8cda2)
   ```
5. ```sh
   $ git config --global alias.graph "log --all --graph --decorate --oneline"
   ```
6. ```sh
   $ git config --global core.excludesfile ~/.gitignore_global
   $ echo .DS_Store > ~/.gitignore_global
   ```
7. See https://github.com/missing-semester/missing-semester/pull/161.
</details>

<details>
<summary>Debugging and Profiling</summary>

#### Debugging
1. ```sh
   $ log show --last 1d | grep sudo | wc
      565    8327   88040
   $ log show --last 1d | grep sudo | head
   2021-08-11 22:24:49.156736+0900 0x3f78f5   Activity    0x3a7820             90998  0    sudo: (libsystem_info.dylib) Performance impact - Resolve user group list (>17 groups)
   2021-08-11 22:24:49.156746+0900 0x3f78f5   Default     0x0                  90998  0    sudo: (libsystem_info.dylib) Too many groups requested (2147483647).  Can cause performance issues when network directories are involved
   2021-08-11 22:24:49.158042+0900 0x3f78f5   Activity    0x3a7821             90998  0    sudo: (libsystem_info.dylib) Performance impact - Resolve user group list (>17 groups)
   2021-08-11 22:24:49.158043+0900 0x3f78f5   Default     0x0                  90998  0    sudo: (libsystem_info.dylib) Too many groups requested (24).  Can cause performance issues when network directories are involved
   2021-08-11 22:24:49.162401+0900 0x3f78f5   Activity    0x3a7822             90998  0    sudo: (libsystem_info.dylib) Retrieve User by Name
   2021-08-11 22:24:49.174246+0900 0x3f78f8   Activity    0x3a7830             90999  0    sudo: (libsystem_info.dylib) Performance impact - Resolve user group list (>17 groups)
   2021-08-11 22:24:49.174256+0900 0x3f78f8   Default     0x0                  90999  0    sudo: (libsystem_info.dylib) Too many groups requested (2147483647).  Can cause performance issues when network directories are involved
   2021-08-11 22:24:49.174780+0900 0x3f78f8   Activity    0x3a7831             90999  0    sudo: (libsystem_info.dylib) Performance impact - Resolve user group list (>17 groups)
   2021-08-11 22:24:49.174780+0900 0x3f78f8   Default     0x0                  90999  0    sudo: (libsystem_info.dylib) Too many groups requested (24).  Can cause performance issues when network directories are involved
   2021-08-11 22:24:49.175425+0900 0x3f78f8   Activity    0x3a7832             90999  0    sudo: (libsystem_info.dylib) Retrieve User by Name
   ```
2. Done.
3. We call the given script `hq.sh`.

   `shellcheck` on `hq.sh`:
   ```sh
   $ shellcheck hq.sh

   In tmp.sh line 3:
   for f in $(ls *.m3u)
            ^---------^ SC2045: Iterating over ls output is fragile. Use globs.
               ^-- SC2035: Use ./*glob* or -- *glob* so names with dashes won't become options.


   In tmp.sh line 5:
   grep -qi hq.*mp3 $f \
            ^-----^ SC2062: Quote the grep pattern so the shell won't interpret it.
                     ^-- SC2086: Double quote to prevent globbing and word splitting.

   Did you mean:
   grep -qi hq.*mp3 "$f" \


   In tmp.sh line 6:
      && echo -e 'Playlist $f contains a HQ file in mp3 format'
               ^-- SC3037: In POSIX sh, echo flags are undefined.
                  ^-- SC2016: Expressions don't expand in single quotes, use double quotes for that.

   For more information:
   https://www.shellcheck.net/wiki/SC2045 -- Iterating over ls output is fragi...
   https://www.shellcheck.net/wiki/SC2062 -- Quote the grep pattern so the she...
   https://www.shellcheck.net/wiki/SC3037 -- In POSIX sh, echo flags are undef...
   ```
   Fixed script:
   ```sh
   #!/bin/sh
   ## Example: a typical script with several problems
   for f in *.m3u
   do
      grep -qi "hq.*mp3" "$f" \
      && echo "Playlist $f contains a HQ file in mp3 format"
   done
   ```
4. Skipped.
#### Profiling
1. Changing the code a bit to call one function rather than all the 3 functions, we get the following.

   `quicksort()`:
   ```sh
   $ python -m cProfile -s tottime sorts.py | head -15
            235363 function calls (203240 primitive calls) in 0.101 seconds

      Ordered by: internal time

      ncalls  tottime  percall  cumtime  percall filename:lineno(function)
    33096/1000    0.032    0.000    0.048    0.000 sorts.py:23(quicksort)
       25399    0.015    0.000    0.032    0.000 random.py:290(randrange)
       25399    0.013    0.000    0.018    0.000 random.py:237 (_randbelow_with_getrandbits)
       25399    0.008    0.000    0.040    0.000 random.py:334(randint)
       16048    0.007    0.000    0.007    0.000 sorts.py:28(<listcomp>)
       16048    0.007    0.000    0.007    0.000 sorts.py:27(<listcomp>)
        1000    0.006    0.000    0.044    0.000 sorts.py:6(<listcomp>)
       32117    0.003    0.000    0.003    0.000 {method 'getrandbits' of  '_random.Random' objects}
       33104    0.003    0.000    0.003    0.000 {built-in method  builtins.len}
       25399    0.002    0.000    0.002    0.000 {method 'bit_length' of  'int' objects}
   ```
   `insertionsort()`:
   ```sh
   $ python -m cProfile -s tottime sorts.py | head -15
            140843 function calls (140816 primitive calls) in 0.082 seconds

      Ordered by: internal time

      ncalls  tottime  percall  cumtime  percall filename:lineno(function)
        1000    0.031    0.000    0.031    0.000 sorts.py:11 (insertionsort)
       25736    0.015    0.000    0.032    0.000 random.py:290(randrange)
       25736    0.012    0.000    0.017    0.000 random.py:237 (_randbelow_with_getrandbits)
       25736    0.008    0.000    0.039    0.000 random.py:334(randint)
        1000    0.006    0.000    0.044    0.000 sorts.py:6(<listcomp>)
       32537    0.003    0.000    0.003    0.000 {method 'getrandbits' of  '_random.Random' objects}
       25736    0.002    0.000    0.002    0.000 {method 'bit_length' of  'int' objects}
           1    0.002    0.002    0.079    0.079 sorts.py:4(test_sorted)
           4    0.001    0.000    0.001    0.000 {built-in method _imp. create_dynamic}
        1000    0.001    0.000    0.001    0.000 {built-in method  builtins.sorted}
   ```
   Now we further change the code to use `line_profiler`.
   ```sh
   $ tail sorts.py
      return array

   if __name__ == '__main__':
      array = random.sample(range(2000), 1000)
      algorithm = quicksort

      lp = LineProfiler()
      lp_wrapper = lp(algorithm)
      lp_wrapper(array)
      lp.print_stats()
   ```
   `quicksort()`:
   ```sh
   $ ipython sorts.py
   Timer unit: 1e-06 s

   Total time: 0.007301 s
   File: /Users/kumatheworld/tmp/line_profiler/sorts.py
   Function: quicksort at line 24

   Line #      Hits         Time  Per Hit   % Time  Line Contents
   ==============================================================
      24                                           def quicksort(array):
      25      1331        783.0      0.6     10.7      if len(array) <= 1:
      26       666        304.0      0.5      4.2          return array
      27       665        367.0      0.6      5.0      pivot = array[0]
      28       665       2694.0      4.1     36.9      left = [i for i in array[1:] if i < pivot]
      29       665       2702.0      4.1     37.0      right = [i for i in array[1:] if i >= pivot]
      30       665        451.0      0.7      6.2      return quicksort(left) + [pivot] + quicksort(right)
   ```
   `insertionsort()`:
   ```sh
   $ ipython sorts.py
   Timer unit: 1e-06 s

   Total time: 0.317805 s
   File: /Users/kumatheworld/tmp/line_profiler/sorts.py
   Function: insertionsort at line 12

   Line #      Hits         Time  Per Hit   % Time  Line Contents
   ==============================================================
      12                                           def insertionsort(array):
      13
      14      1001        388.0      0.4      0.1      for i in range(len(array)):
      15      1000        435.0      0.4      0.1          j = i-1
      16      1000        374.0      0.4      0.1          v = array[i]
      17    236649     112488.0      0.5     35.4          while j >= 0 and v < array[j]:
      18    235649     112387.0      0.5     35.4              array[j+1] = array[j]
      19    235649      91303.0      0.4     28.7              j -= 1
      20      1000        429.0      0.4      0.1          array[j+1] = v
      21         1          1.0      1.0      0.0      return array
   ```
   Those results show that `quicksort()` was much faster than `insertionsort()` when the array was large.

   For memory profiling, as `quicksort()` is a recusrive function and `memory_profiler` is invoked every time the function is called, we create another function that externally calls `quicksort()`.
   ```sh
   $ tail sorts.py

   @profile
   def quicksort_(array):
      return quicksort(array)

   if __name__ == '__main__':
      array = random.sample(range(2000), 1000)
      algorithm = quicksort_

      algorithm(array)
   ```
   The profiling results are as follows.
   `quicksort()`:
   ```sh
   $ python -m memory_profiler sorts.py
   Filename: sorts.py

   Line #    Mem usage    Increment  Occurences   Line Contents
   ============================================================
      32     38.7 MiB     38.7 MiB           1   @profile
      33                                         def quicksort_(array):
      34     38.7 MiB      0.0 MiB           1       return quicksort(array)
   ```
   `insertionsort()`:
   ```sh
   $ python -m memory_profiler sorts.py
   Filename: sorts.py

   Line #    Mem usage    Increment  Occurences   Line Contents
   ============================================================
      12     38.8 MiB     38.8 MiB           1   @profile
      13                                         def insertionsort(array):
      14
      15     38.8 MiB      0.0 MiB        1001       for i in range(len(array)):
      16     38.8 MiB      0.0 MiB        1000           j = i-1
      17     38.8 MiB      0.0 MiB        1000           v = array[i]
      18     38.8 MiB      0.0 MiB      255584           while j >= 0 and v < array[j]:
      19     38.8 MiB      0.0 MiB      254584               array[j+1] = array[j]
      20     38.8 MiB      0.0 MiB      254584               j -= 1
      21     38.8 MiB      0.0 MiB        1000           array[j+1] = v
      22     38.8 MiB      0.0 MiB           1       return array


   ```
   Those results show no significant difference in memory consumption. Actually, the memory usage remains 38.7 or 38.8 MB even if we double or halve the size of the array, which means that the Mem usage number is dominated by some overhead that the array has nothing to do with. If we make the array so large (like 10^7) that the memory usage exceeds 38.8 MB, `insertionsort()` will take too long. Theoretically, however, `quicksort()` will use more space as it creates other arrays while all `insertionsort()` does is swapping some elements in the given array.

   The `perf` challenge is skipped as I do not have an environment for that.
2. Before uncommenting the commented lines:
   ```sh
   $ pycallgraph graphviz -- ./fib.py
   34
   ```
   Looking at the [generated graph](pycallgraph.png), we see that `fib0()` was called 21 times.

   After uncommenting them:
   ```sh
   $ pycallgraph graphviz -- ./fib.py
   34
   ```
   Looking at the [newly generated graph](pycallgraph_uncommented.png), we see that each `fibN()` was called just once.
3. ```sh
   $ python -m http.server 4444
   Serving HTTP on :: port 4444 (http://[::]:4444/) ...
   ```
   ```sh
   $ lsof | grep LISTEN
   rapportd    443 kumatheworld    5u     IPv4 0xca46f179b94679c3        0t0                 TCP *:59470 (LISTEN)
   rapportd    443 kumatheworld    6u     IPv6 0xca46f179c8b0cefb        0t0                 TCP *:59470 (LISTEN)
   LINE       1313 kumatheworld    9u     IPv4 0xca46f179c8990e13        0t0                 TCP localhost:10400 (LISTEN)
   Dropbox    2267 kumatheworld   81u     IPv6 0xca46f179c8b0c23b        0t0                 TCP *:17500 (LISTEN)
   Dropbox    2267 kumatheworld   82u     IPv4 0xca46f179c89940db        0t0                 TCP *:17500 (LISTEN)
   Dropbox    2267 kumatheworld  116u     IPv4 0xca46f179b9466f9b        0t0                 TCP localhost:17600 (LISTEN)
   Dropbox    2267 kumatheworld  121u     IPv4 0xca46f179c8c3983b        0t0                 TCP localhost:17603 (LISTEN)
   Python    20565 kumatheworld    4u     IPv6 0xca46f179ccd0023b        0t0                 TCP *:krb524 (LISTEN)
   $ kill 20565
   ```
4. ```sh
   $ stress -c 3
   stress: info: [29529] dispatching hogs: 3 cpu, 0 io, 0 vm, 0 hdd
   ```
   While this command was being executed, `htop` showed that The occupancy of 3 CPUs were constantly over 80%. The rest of the exercise are skipped due to an environmental problem.
5. ```sh
   $ sudo tshark -Y http
   Capturing on 'Wi-Fi: en0'
   ```
   While doing this, I executed `curl ipinfo.io` on a separate terminal.
   ```sh
   $ curl ipinfo.io
   {
   "ip": "118.240.150.114",
   "hostname": "fp76f09672.tkyc411.ap.nuro.jp",
   "city": "Tokyo",
   "region": "Tokyo",
   "country": "JP",
   "loc": "35.6895,139.6917",
   "org": "AS2527 Sony Network Communications Inc.",
   "postal": "151-0052",
   "timezone": "Asia/Tokyo",
   "readme": "https://ipinfo.io/missingauth"
   }
   ```
   As the request was sent, I got the following from the terminal that `tshark` was being executed on.
   ```sh
   93   5.301986  192.168.1.8 ??? 34.117.59.81 HTTP 139 GET / HTTP/1.1
   97   5.437739 34.117.59.81 ??? 192.168.1.8  HTTP/JSON 748 HTTP/1.1 200 OK , JavaScript Object Notation (application/json)
   ```
</details>

<details>
<summary>Metaprogramming</summary>

1. I added the following lines in `Makefile`.
   ```Makefile

   .PHONY: clean
   clean:
         rm *aux *pdf *png *log
   ```
   If you are in a `.git` repository and set `.gitignore` properly, you can replace the last line by the following.
   ```sh
   git clean -xf
   ```
2. I do use comparison requirements a lot in `requirements.txt` of my personal Python projects as it is very straightforward. Wildcard and multiple requirements are also straightforward and will be useful as well. However, I do not really come up with cases where caret and tilde requirements make a lot of sense.
3. I added a file named `pre-commit` in `.git/hooks/`, in which the following line is written.
   ```sh
   make paper.pdf
   ```
   When I made a non-compilable change add tried commit it, the commit was not successful as expected.
   ```sh
   $ git log --oneline
   e07a25b (HEAD -> master) Initial commit
   $ git status --short
   $ echo a >> plot.py
   $ git commit -am "Add garbage"
   ./plot.py -i data.dat -o plot-data.png
      File "./plot.py", line 14
         plt.savefig(args.o)a
                            ^
   SyntaxError: invalid syntax
   make: *** [plot-data.png] Error 1
   $ git log --oneline
   e07a25b (HEAD -> master) Initial commit
   ```
   On the other hand, when I made a compilable change and tried to commit it, the commit was successful.
   ```sh
   $ echo "6 6" >> data.dat
   $ git commit -am "Add data"
   ./plot.py -i data.dat -o plot-data.png
   pdflatex paper.tex
   This is pdfTeX, Version 3.141592653-2.6-1.40.22 (TeX Live 2021) (preloaded format=pdflatex)
   restricted \write18 enabled.
   entering extended mode
   (./paper.tex
   LaTeX2e <2020-10-01> patch level 4
   L3 programming layer <2021-02-18>
   (/usr/local/texlive/2021/texmf-dist/tex/latex/base/article.cls
   Document Class: article 2020/04/10 v1.4m Standard LaTeX document class
   (/usr/local/texlive/2021/texmf-dist/tex/latex/base/size10.clo))
   (/usr/local/texlive/2021/texmf-dist/tex/latex/graphics/graphicx.sty
   (/usr/local/texlive/2021/texmf-dist/tex/latex/graphics/keyval.sty)
   (/usr/local/texlive/2021/texmf-dist/tex/latex/graphics/graphics.sty
   (/usr/local/texlive/2021/texmf-dist/tex/latex/graphics/trig.sty)
   (/usr/local/texlive/2021/texmf-dist/tex/latex/graphics-cfg/graphics.cfg)
   (/usr/local/texlive/2021/texmf-dist/tex/latex/graphics-def/pdftex.def)))
   (/usr/local/texlive/2021/texmf-dist/tex/latex/l3backend/l3backend-pdftex.def)
   No file paper.aux.
   (/usr/local/texlive/2021/texmf-dist/tex/context/base/mkii/supp-pdf.mkii
   [Loading MPS to PDF converter (version 2006.09.02).]
   ) (/usr/local/texlive/2021/texmf-dist/tex/latex/epstopdf-pkg/epstopdf-base.sty
   (/usr/local/texlive/2021/texmf-dist/tex/latex/latexconfig/epstopdf-sys.cfg))
   Overfull \hbox (45.79955pt too wide) in paragraph at lines 4--5
   [][]
   [1{/usr/local/texlive/2021/texmf-var/fonts/map/pdftex/updmap/pdftex.map} <./plo
   t-data.png>] (./paper.aux) )
   (see the transcript file for additional information)</usr/local/texlive/2021/te
   xmf-dist/fonts/type1/public/amsfonts/cm/cmr10.pfb>
   Output written on paper.pdf (1 page, 24064 bytes).
   Transcript written on paper.log.
   [master f33fcf5] Add data
   1 file changed, 1 insertion(+), 1 deletion(-)
   $ git log --oneline
   f33fcf5 (HEAD -> master) Add data
   e07a25b Initial commit
   ```
4. I have my own GitHub page [here](https://kumatheworld.github.io/) but would not like to add a GitHub Action to run `shellcheck` as the website is nothing to do with shellscripts so far. However, on another [respository](https://github.com/kumatheworld/textbook-solutions), I have set a GitHub Action that generates PDF files from LaTeX sources and is triggered by pushing a tagged commit.
5. See [.github/](.github/), https://github.com/kumatheworld/missing-semester/pull/1 and https://github.com/kumatheworld/missing-semester/actions.
</details>

<details>
<summary>Security and Cryptography</summary>

1. Entropy.

   1. 4 * log(100000) = 66.44 bits.
   2. 8 * log(2*26+10) = 47.63 bits.
   3. The first one is stronger in terms of entropy since having more bits means being harder to guess.
   4. First of all, let us review the following fact: if we play a game where we win at probability p, then the expected number of attempts until we win for the first time is 1/p. We use this to derive the estimated times below. <br>
   Now, assuming that we know ahead of time that the password consists of 4 words, the first case will take (100000^4 / 10000) secs = 10^16 secs = 317 million years. <br>
   For the second case, assuming that we know ahead of time that the password consists of 8 characters, it will take (62^8 / 10000) secs = 2.18 * 10^10 secs = 692 years.
2. Cryptographic hash functions.
   ```sh
   $ wget --no-check-certificate https://debian.xfree.com.ar/debian-cd/current/amd64/iso-cd/debian-11.0.0-amd64-netinst.iso
   --2021-09-06 19:39:10--  https://debian.xfree.com.ar/debian-cd/current/amd64/iso-cd/debian-11.0.0-amd64-netinst.iso
   Resolving debian.xfree.com.ar (debian.xfree.com.ar)... 190.111.255.148
   Connecting to debian.xfree.com.ar (debian.xfree.com.ar)|190.111.255.148|:443... connected.
   WARNING: no certificate subject alternative name matches
         requested host name ???debian.xfree.com.ar???.
   HTTP request sent, awaiting response... 200 OK
   Length: 395313152 (377M) [application/x-iso9660-image]
   Saving to: ???debian-11.0.0-amd64-netinst.iso???

   debian-11.0.0-amd64-netinst.iso   100%[=============================================================>] 377.00M  5.54MB/s    in 13m 40s

   2021-09-06 19:52:52 (471 KB/s) - ???debian-11.0.0-amd64-netinst.iso??? saved [395313152/395313152]

   $ sha256sum debian-11.0.0-amd64-netinst.iso
   ae6d563d2444665316901fe7091059ac34b8f67ba30f9159f7cef7d2fdc5bf8a  debian-11.0.0-amd64-netinst.iso
   $ curl https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS
   ae6d563d2444665316901fe7091059ac34b8f67ba30f9159f7cef7d2fdc5bf8a  debian-11.0.0-amd64-netinst.iso
   de5ce53ec0b2a84b2f3f1f1128138e9e6228a1e4315312b8ac3024099e835de4  debian-edu-11.0.0-amd64-netinst.iso
   c117f904cf51278923814f5b92c171e56726eb43c8895eb9258dc5b3b1c71400  debian-mac-11.0.0-amd64-netinst.iso
   ```
3. Symmetric cryptography.
   ```sh
   $ echo foo > bar
   $ openssl aes-256-cbc -salt -in bar -out baz
   enter aes-256-cbc encryption password:
   Verifying - enter aes-256-cbc encryption password:
   $ cat baz; echo
   Salted__???B
   l	w???????????X???b???@??????????????????3
   $ hexdump baz
   0000000 53 61 6c 74 65 64 5f 5f ca 42 0a 6c 09 77 c0 ff
   0000010 cd b1 b4 58 cd 62 e1 40 97 a1 f6 b0 82 a1 12 33
   0000020
   $ openssl aes-256-cbc -d -in baz -out qux
   enter aes-256-cbc decryption password:
   $ cmp bar qux
   ```
4. Asymmetric cryptography.

   1. Already done in the past. Run `ssh-keygen`.
   2. ``` sh
      $ gpg --gen-key
      gpg (GnuPG) 2.3.2; Copyright (C) 2021 Free Software Foundation, Inc.
      This is free software: you are free to change and redistribute it.
      There is NO WARRANTY, to the extent permitted by law.

      Note: Use "gpg --full-generate-key" for a full featured key generation dialog.

      GnuPG needs to construct a user ID to identify your key.

      Real name: Yoshihiro Kumazawa
      Email address: kumatheworld1105@yahoo.co.jp
      You selected this USER-ID:
         "Yoshihiro Kumazawa <kumatheworld1105@yahoo.co.jp>"

      Change (N)ame, (E)mail, or (O)kay/(Q)uit? O
      We need to generate a lot of random bytes. It is a good idea to perform
      some other action (type on the keyboard, move the mouse, utilize the
      disks) during the prime generation; this gives the random number
      generator a better chance to gain enough entropy.
      We need to generate a lot of random bytes. It is a good idea to perform
      some other action (type on the keyboard, move the mouse, utilize the
      disks) during the prime generation; this gives the random number
      generator a better chance to gain enough entropy.
      gpg: /Users/kumatheworld/.gnupg/trustdb.gpg: trustdb created
      gpg: key 2B27336C85F0AE58 marked as ultimately trusted
      gpg: directory '/Users/kumatheworld/.gnupg/openpgp-revocs.d' created
      gpg: revocation certificate stored as '/Users/kumatheworld/.gnupg/openpgp-revocs.d/A278A1BB9BB60E72601B81882B27336C85F0AE58.rev'
      public and secret key created and signed.

      pub   ed25519 2021-09-09 [SC] [expires: 2023-09-09]
            A278A1BB9BB60E72601B81882B27336C85F0AE58
      uid                      Yoshihiro Kumazawa <kumatheworld1105@yahoo.co.jp>
      sub   cv25519 2021-09-09 [E] [expires: 2023-09-09]
      ```
   3. I think sending him an e-mail is too much since I wasn't taking the course. Instead, I encrypt and decrypt this very README.md here.
      ```sh
      $ gpg --encrypt --sign --armor -r kumatheworld1105@yahoo.co.jp README.md
      $ head README.md.asc
      -----BEGIN PGP MESSAGE-----

      hF4DcEX6Bcv8chkSAQdAPfRQRX4/zQMHJ0AZ3eIqyA3K4QAIEeWP+zgK0eCvEHow
      5Elg6MNYagWCqI3cVoxAYPWL0SV/BDoYej7EgG302EbfeLSbYm7v3McDjErVyF7+
      1O0BCQIVutTnDiK4q1L0xZlxQEtv2G4/5astop55amxkkQMJ9572efzqT6WXzhYJ
      QtpaSk3W9KVVROeSPbPpqTPeuCbPyNVLN99ETH7lPjyMZhrtPHAUewow++YU3c6m
      EW9xE2KLYCCpDXjhO2FBW5QVkRfivos9akOpYPga08E+MZXySMqF9qO8oNphySpf
      dyIUeq2KLdEVy6YOLp8qT/gKw4JrMevyhSVxpw+Nya3z+H23sDVi9Xh2+3FSuEvZ
      AwhXRr+QHc1L3mUgb/lxOdhXLdhnNkclEk59O8okTB62eiGuz43Uot101a7h8oXC
      cwvcwT0uFtOC7b79mMpLaFcsdOG8Yl6z6h33vav1LUtZ1JaSMk7HQhvaODQgKUNq
      $ gpg README.md.asc
      gpg: WARNING: no command supplied.  Trying to guess what you mean ...
      gpg: encrypted with cv25519 key, ID 7045FA05CBFC7219, created 2021-09-09
            "Yoshihiro Kumazawa <kumatheworld1105@yahoo.co.jp>"
      File 'README.md' exists. Overwrite? (y/N) N
      Enter new filename: README.md.dec
      gpg: Signature made Fri Sep 10 19:39:26 2021 JST
      gpg:                using EDDSA key A278A1BB9BB60E72601B81882B27336C85F0AE58
      gpg: Good signature from "Yoshihiro Kumazawa <kumatheworld1105@yahoo.co.jp>" [ultimate]
      $ cmp README.md{,.dec}
      ```
   4. ```sh
      $ export GPG_TTY=$(tty)
      $ gpg --list-secret-keys --keyid-format LONG
      /Users/kumatheworld/.gnupg/pubring.kbx
      --------------------------------------
      sec   ed25519/2B27336C85F0AE58 2021-09-09 [SC] [expires: 2023-09-09]
            A278A1BB9BB60E72601B81882B27336C85F0AE58
      uid                 [ultimate] Yoshihiro Kumazawa <kumatheworld1105@yahoo.co.jp>
      ssb   cv25519/7045FA05CBFC7219 2021-09-09 [E] [expires: 2023-09-09]

      $ git config --global user.signingkey 2B27336C85F0AE58
      $ git tag v0.0 -sm "Dummy tag for the next exercise"
      $ git tag -v v0.0
      object 5b2757c1d14faac04d5332c3841216f731742bb8
      type commit
      tag v0.0
      tagger kumatheworld <kumatheworld1105@yahoo.co.jp> 1631341816 +0900

      Dummy tag for the next exercise
      gpg: Signature made Sat Sep 11 15:30:16 2021 JST
      gpg:                using EDDSA key A278A1BB9BB60E72601B81882B27336C85F0AE58
      gpg: Good signature from "Yoshihiro Kumazawa <kumatheworld1105@yahoo.co.jp>" [ultimate]
      ```
</details>
