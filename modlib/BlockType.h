#ifndef MODLIB_BLOCKTYPE_H
#define MODLIB_BLOCKTYPE_H

#define test 1 + 2 + 3 + 4 + 5

typedef int pute;

typedef struct BlockType {
	char* texture;
	char* name;
} BlockType;

struct lol {
	int prout;
};

BlockType* blockType_create();

int plus(int a, int b);
int mult(int a, int b) {
	return a * b;
}

struct A {
    char c;
    signed char sc;
    unsigned char uc;
    short s;
    short int si;
    signed short ss;
    signed short int ssi;
    unsigned short us;
    unsigned short int usi;
    int i;
    signed sig;
    signed int sigi;
    unsigned u;
    unsigned int ui;
    long l;
    long int li;
    signed long sl;
    signed long int sli;
    unsigned long ul;
    unsigned long int uli;
    long long ll;
    long long int lli;
    signed long long sll;
    signed long long int slli;
    unsigned long long ull;
    unsigned long long int ulli;
    float g;
    double d;
    // long double ld;
}

#endif // MODLIB_BLOCKTYPE_H