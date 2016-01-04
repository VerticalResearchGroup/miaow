#include "helper.h"

FILE *config_file;
FILE *instrmem_file;
FILE *datamem_file;

configValues configs;

#ifdef WIN32
#include <vector>
char *optarg = nullptr;

char getopt(int argc, char **argv, const char* pattern)
{
    std::vector<std::string> options;
    char return_value;
    static int arg_post = 1;
    if (argc < 2)
        return -1;

    std::string string_pattern(pattern);

    while (arg_post < argc)
    {
        if (argv[arg_post][0] != '-')
        {
            ++arg_post;
            continue;
        }

        if (strlen(argv[arg_post]) == 1)
        {
            ++arg_post;
            continue;
        }

        if (string_pattern.find(argv[arg_post][1]) != std::string::npos)
        {
            return_value = argv[arg_post][1];
            ++arg_post;
            if (argv[arg_post][0] != '-')
            {
                optarg = argv[arg_post];
            }

            return return_value;
        }
    }

    return -1;
}
#endif

void printInstruction32(void* instr)
{
    int *x = static_cast<int*>(instr);
    char buff[10];
#ifdef WIN32
    sprintf_s(buff, "%08X", *x);
#else
    sprintf(buff, "%08X", *x);
#endif
    fprintf(instrmem_file, "%c%c\n", buff[6], buff[7]);
    fprintf(instrmem_file, "%c%c\n", buff[4], buff[5]);
    fprintf(instrmem_file, "%c%c\n", buff[2], buff[3]);
    fprintf(instrmem_file, "%c%c\n", buff[0], buff[1]);
}

void printInstruction64(void* instr)
{
    int *x = static_cast<int*>(instr);
    char buff[10];
#ifdef WIN32
    sprintf_s(buff, "%08X", *x);
#else
    sprintf(buff, "%08X", *x);
#endif
    fprintf(instrmem_file, "%c%c\n", buff[6], buff[7]);
    fprintf(instrmem_file, "%c%c\n", buff[4], buff[5]);
    fprintf(instrmem_file, "%c%c\n", buff[2], buff[3]);
    fprintf(instrmem_file, "%c%c\n", buff[0], buff[1]);
#ifdef WIN32
    sprintf_s(buff, "%08X", *(x + 1));
#else
    sprintf(buff, "%08X", *(x + 1));
#endif
    fprintf(instrmem_file, "%c%c\n", buff[6], buff[7]);
    fprintf(instrmem_file, "%c%c\n", buff[4], buff[5]);
    fprintf(instrmem_file, "%c%c\n", buff[2], buff[3]);
    fprintf(instrmem_file, "%c%c\n", buff[0], buff[1]);
}

// TODO: Change number of instructions
// since the count can change due to memory instructions
void writeConfigFile()
{
    int i, j, m, n;

    fprintf(config_file,
        "%d;%d;\n", configs.wgrp_count, configs.thrd_count);

    for (i = 0; i < configs.wgrp_count; i++) {
        for (j = 0; j < configs.wfrt_count; j++) {
            fprintf(config_file,
                "%d;%d;%d;%d;%d;%d;%d;",
                i, j, configs.wfrt_count, configs.w_thrd_cnt[j],
                configs.vector_reg, configs.scalar_reg, configs.data_memory);

            // initialize vector register values
            for (n = 0; n < configs.thrd_count; n++) {
                fprintf(config_file, "V%d:", n);

                for (m = 0; m < (configs.scalar_reg - 1); m++) {
                    fprintf(config_file, "%d=%d,", m, (rand() % MAX_IMM_VAL));
                }

                fprintf(config_file, "%d=%d;", m, (rand() % MAX_IMM_VAL));
            }

            // initialize scalar register values
            fprintf(config_file, "S:");

            for (m = 0; m < (configs.scalar_reg - 1); m++) {
                fprintf(config_file, "%d=%d,", m, (rand() % MAX_IMM_VAL));
            }

            fprintf(config_file, "%d=%d;", m, (rand() % MAX_IMM_VAL));

            // append start pc
            fprintf(config_file, "%d\n", (i * configs.instr_count));
        }
    }
}

void writeDataMemFile()
{
    int i;
    fprintf(datamem_file, "@0\n");

    for (i = 0; i < configs.data_memory; i++) {
        fprintf(datamem_file, "%02X\n", rand() % 256);
    }
}

void shuffleArray(int *arr, int size)
{
    int i, j, t;

    for (i = (size - 1); i > 0; i--) {
        j = rand() % i;
        t = arr[i];
        arr[i] = arr[j];
        arr[j] = t;
    }
}

void usage(char *prog)
{
    fprintf(stderr, "Usage: %s -i <instruction_mix> -r <registers> -m <data_memory> -c <instr_count>\n\n", prog);
    fprintf(stderr, "Options: (All required)\n");
    fprintf(stderr, "  i: Instruction mix represented as ratio.\n");
    fprintf(stderr, "     <scalar_alu_instr>:<vector_alu_instr>:<scalar_mem_instr>:<vector_mem_instr>\n");
    fprintf(stderr, "  r: Absolute number of scalar and vector registers.\n");
    fprintf(stderr, "     <scalar_reg>:<vector_reg>\n");
    fprintf(stderr, "  m: Data memory required\n");
    fprintf(stderr, "  c: Total instruction count\n");
    fprintf(stderr, "  t: Number of threads per wavegroup\n");
    fprintf(stderr, "  w: Number of wavegroups\n");
    fprintf(stderr, "  n: Number of tests to generate\n");
    fprintf(stderr, "  u: Create unit tests (i, c, w, g are overridden)\n");

    exit(1);
}

void parseArgs(int argc, char *argv[]) {
    configs.wgrp_count = -1;
    configs.thrd_count = -1;

    configs.scalar_alu = -1;
    configs.vector_alu = -1;

    configs.scalar_mem = -1;
    configs.vector_mem = -1;

    configs.scalar_reg = -1;
    configs.vector_reg = -1;

    configs.data_memory = -1;
    configs.instr_count = -1;

    configs.test_count = 1;
    configs.unit_tests = 0;

    char option;
    char *tok, *temp = NULL;

    while ((option = getopt(argc, argv, "i:r:m:c:t:w:g:u:n:")) != -1) {
        switch (option) {
        case 'i':
#ifdef WIN32
            tok = strtok_s(optarg, ":", &temp);
#else
            temp = strdup(optarg);
            tok = strtok(temp, ":");
#endif


            configs.scalar_alu = atoi(tok);
#ifdef WIN32
            tok = strtok_s(NULL, ":", &temp);
#else
            tok = strtok(NULL, ":");
#endif
            configs.vector_alu = atoi(tok);

#ifdef WIN32
            tok = strtok_s(NULL, ":", &temp);
#else
            tok = strtok(NULL, ":");
#endif
            configs.scalar_mem = atoi(tok);

#ifdef WIN32
            tok = strtok_s(NULL, ":", &temp);
#else
            tok = strtok(NULL, ":");
#endif
            configs.vector_mem = atoi(tok);
#ifndef WIN32
            free(temp);
#endif
            break;
        case 'r':
#ifdef WIN32
            tok = strtok_s(optarg, ":", &temp);
#else
            temp = strdup(optarg);
            tok = strtok(temp, ":");
#endif
            configs.scalar_reg = atoi(tok);

#ifdef WIN32
            tok = strtok_s(NULL, ":", &temp);
#else
            tok = strtok(NULL, ":");
#endif
            configs.vector_reg = atoi(tok);

#ifndef WIN32
            free(temp);
#endif
            break;
        case 'm':
            configs.data_memory = atoi(optarg);
            break;
        case 'c':
            configs.instr_count = atoi(optarg);
            break;
        case 't':
            configs.thrd_count = atoi(optarg);
            break;
        case 'w':
            configs.wgrp_count = atoi(optarg);
            break;
        case 'n':
            configs.test_count = atoi(optarg);
            break;
        case 'u':
            configs.unit_tests = 1;
            break;
        default:
            usage(argv[0]);
        }
    }

    if (configs.unit_tests == 1) {
        configs.wgrp_count = 1;
        configs.thrd_count = configs.thrd_count % 64;
    }

    if (configs.wgrp_count == -1 || configs.thrd_count == -1) {
        usage(argv[0]);
    }

    if (configs.unit_tests == 0 &&
        (configs.scalar_alu == -1 || configs.vector_alu == -1 ||
            configs.scalar_mem == -1 || configs.vector_mem == -1 ||
            configs.scalar_reg == -1 || configs.vector_reg == -1 ||
            configs.data_memory == -1 || configs.instr_count == -1)) {
        usage(argv[0]);
    }

    //if (configs.unit_tests == 1 &&
    //    (configs.scalar_reg == -1 || configs.vector_reg == -1 ||
    //        configs.data_memory == -1)) {
    // At present configs.data_memory isn't actually used anywhere, disabling
    // the check for it until it actually matters.
    if (configs.unit_tests == 1 &&
        (configs.scalar_reg == -1 || configs.vector_reg == -1)) {
        usage(argv[0]);
    }

    configs.wfrt_count = configs.thrd_count / 64;
    int i;

    for (i = 0; i < configs.wfrt_count; i++) {
        configs.w_thrd_cnt[i] = 64;
    }

    if (configs.thrd_count % 64 != 0) {
        configs.wfrt_count = configs.wfrt_count + 1;
        configs.w_thrd_cnt[i] = (configs.thrd_count % 64);
    }
}

void openOutputFiles()
{
#ifdef WIN32
    fopen_s(&config_file, "unit_test_config.txt", "w");
    fopen_s(&instrmem_file, "unit_test_instr.mem", "w");
    fopen_s(&datamem_file, "unit_test_data.mem", "w");
#else
    config_file = fopen("unit_test_config.txt", "w");
    instrmem_file = fopen("unit_test_instr.mem", "w");
    datamem_file = fopen("unit_test_data.mem", "w");
#endif

    fprintf(instrmem_file, "@0\n");
}

void closeOutputFiles()
{
    fclose(config_file);
    fclose(instrmem_file);
    fclose(datamem_file);
}
