# missing-semester
My Exercise Solutions for [The Missing Semester of Your CS Education, Winter 2020](https://missing.csail.mit.edu/2020/) from MIT.

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
   Those figures show that `quicksort()` and `insertionsort()` took 0.032ms and 0.031ms respectively. The bottlenecks of those algorithms are the list comprehensions.
</details>
