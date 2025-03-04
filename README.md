This repository contains a GitHub Actions job building GCC compiler for BPF backend from latest [GCC source code snapshots](https://gcc.gnu.org/snapshots.html).

Built artifacts are published as releases in this repository. The releases are then used by CI system for testing Linux Kernel BPF (aka [BPF CI](https://github.com/kernel-patches/bpf/actions/workflows/test.yml)).

At this time (Mar 2025) BPF CI job tests whether GCC BPF compiler can successfully build BPF programs from [tools/testing/selftests/bpf](https://web.git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf) directory of the Linux source tree.
