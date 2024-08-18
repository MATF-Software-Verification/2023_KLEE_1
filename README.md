# Beam Stack Search pretraga u okviru alata KLEE

Ovaj rad je posvećen implementaciji *Beam Stack Search* algoritma pretrage u okviru alata za simboličko izvršavanje KLEE, modifikacije *Beam Search* algoritma koji svoje primene najčešće nalazi u oblasti mašinskog učenja, konkretno u obradi prirodnog jezika i mašinskog prevođenja, ali za koji se eksperimentalno pokazuje da ima mogućnosti postizanja izuzetno dobrih rezultata i u realnim primerima upotrebe simboličkog izvršavanja.

Analiza algoritma i dobijenih rezultata može se naći u `SystemDescription.pdf` datoteci (materijali za njenu izradu - .tex i .bib fajl i ilustracije se nalaze u `paper/` direktorijumu).

### Autori
- Aleksandar Stefanović, 1021/2023
- Petar Đorđević, 1088/2022

### Izgradnja alata KLEE

Izvorni kod modifikovanog alata KLEE se nalazi u `klee/` direktorijumu. Za njegovo prevođenje, preporučuje se praćenje [zvaničnog uputstva za izgradnju alata KLEE](https://klee-se.org/build/build-llvm13/). Lista glavnih zavisnosti može se naći na [ovoj stranici](https://klee-se.org/build/dependencies/).

**Napomene:**
- Za izgradnju projekta je neophodno koristiti LLVM 13. Ranije ili novije verzije neće raditi.
- U svim eksperimentima je korišćen [STP](https://github.com/stp/stp) SMT rešavač, pa se za reprodukciju rezultata preporučuje njegova upotreba.
- Za testiranje Coreutils alata, kao što je izvršeno u ovom radu, neophodno je ispratiti korak 5 zvaničnog uputstva. Ostali opcioni koraci se mogu preskočiti.
- Za lakšu upotrebu alata, preporučuje se dodavanje putanje do `klee/build/bin/` direktorijuma u `PATH`.

### Izgradnja Coreutils alata

Svi izvršeni eksperimenti su sprovedeni nad slučajno odabranim podskupom [GNU Coreutils](https://www.gnu.org/software/coreutils/) alata. Za njihovu izgradnju se može ispratiti naredno [uputstvo](https://klee-se.org/tutorials/testing-coreutils/), ali je pružena i pomoćna skripta za automatizaciju procesa izgradnje - `scripts/setup_coreutils.sh`. Nakon uspešnog izvršavanja skripte, u korenu repozitorijuma biće napravljen `coreutils/` direktorijum, gde se u `coreutils/obj-llvm/src/`, između ostalog, nalaze i Coreutils programi u [LLVM Bitcode formatu](https://llvm.org/docs/BitCodeFormat.html), spremni za analizu sa alatom KLEE.

### Upotreba alata za testiranje

Nakon izgradnje, alat KLEE se može pokrenuti sa *Beam Stack Search* pretragom na sledeći način:

    $ klee --search=beam --beam-width=256 --beam-stack-swap-limit=1000000 example.bc

Svi eksperimenti su izvršeni sa opcijama i u okruženju opisanom na [ovoj stranici](http://klee-se.org/docs/coreutils-experiments/). Prema tome, pokretanje *Beam Stack Search* pretrage nad alatom *printf* je izvršeno na sledeći način:

>```$ klee --simplify-sym-indices --write-cvcs --write-cov --output-module --max-memory=1000 --disable-inlining --optimize --use-forked-solver --use-cex-cache --libc=uclibc --posix-runtime --external-calls=all --only-output-states-covering-new --env-file=test.env --run-in-dir=/tmp/sandbox --max-sym-array-size=4096 --max-solver-time=30s --max-time=60min --watchdog --max-memory-inhibit=false --max-static-fork-pct=1 --max-static-solve-pct=1 --max-static-cpfork-pct=1 --switch-type=internal --search=beam ./printf.bc --sym-args 0 3 10 --sym-files 2 12 --sym-stdin 12 --sym-stdout```

Rezultati svih testiranja predstavljenih u radu mogu se naći u direktorijumu `benchmarks/`, organizovanom po alatu nad kojem je izvršena analiza. Za analizu rezultata, potrebno je koristiti `klee-stats` alat, koji se, bez dodatnih opcija, može pokrenuti na sledeći način:

    $ klee-stats benchmarks/beam_run/
