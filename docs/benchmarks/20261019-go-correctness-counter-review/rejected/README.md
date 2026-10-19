The first composition expanded two root methods and failed the API snapshot.
The final internal adapter removes those methods; all 12 tag sets pass.
The first fresh C control lacked the module-local cache and attempted an offline
clone. Its setup failure is not a parser mismatch. The corrected control uses
the existing pinned shared-object cache and reproduces exactly 39 parser failures.
Earlier diagnostic-wrapper setup failures (missing import and error-string
classification) remain in the original local evidence directories.
No failed runtime, memory or timing sample has been discarded.
