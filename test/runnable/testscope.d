// PERMUTE_ARGS:

extern(C) int printf(const char*, ...);

class Eh : Exception
{
    this()
    {
	super("Eh thrown");
    }
}


/********************************************/

class Foo
{
    static int x;

    this()
    {
	assert(x == 0);
	x++;
	printf("Foo.this()\n");
	throw new Eh();
	assert(0);
    }

    ~this()
    {
	printf("Foo.~this()\n");
    }
}

void test1()
{
    try
    {
	auto Foo f = new Foo();
	assert(0);
    }
    catch (Eh)
    {
	assert(Foo.x == 1);
	Foo.x++;
    }
    finally
    {
	assert(Foo.x == 2);
	Foo.x++;
    }
    assert(Foo.x == 3);
}

/********************************************/

void test2()
{
    int x;
    {
	scope (exit) { printf("test1\n"); assert(x == 3); x = 4; }
	scope (exit) { printf("test2\n"); assert(x == 2); x = 3; }
	scope (exit) { printf("test3\n"); assert(x == 1); x = 2; }
	printf("test4\n"); assert(x == 0); x = 1;
    }
    assert(x == 4);
}

/********************************************/

void test3()
{
    int x;
    {
	scope (success) { printf("test1\n"); assert(x == 3); x = 4; }
	scope (success) { printf("test2\n"); assert(x == 2); x = 3; }
	scope (success) { printf("test3\n"); assert(x == 1); x = 2; }
	printf("test4\n"); assert(x == 0); x = 1;
    }
    assert(x == 4);
}

/********************************************/

void test4()
{
    int x;
    try
    {
	scope (exit) { printf("test1\n"); assert(x == 3); x = 4; }
	scope (exit) { printf("test2\n"); assert(x == 2); x = 3; }
	x = 2;
	throw new Eh;
	scope (exit) { printf("test3\n"); assert(x == 1); x = 2; }
	printf("test4\n"); assert(x == 0); x = 1;
    }
    catch (Eh e)
    {
    }
    assert(x == 4);
}

/********************************************/

void test5()
{
    int x;
    try
    {
	scope (success) { printf("test1\n"); assert(x == 3); x = 4; }
	scope (success) { printf("test2\n"); assert(x == 2); x = 3; }
	x = 2;
	throw new Eh;
	scope (success) { printf("test3\n"); assert(x == 1); x = 2; }
	printf("test4\n"); assert(x == 0); x = 1;
    }
    catch (Eh e)
    {
    }
    assert(x == 2);
}

/********************************************/

void test6()
{
    int x;
    scope (failure) { assert(0); }
    try
    {
	scope (failure) { printf("test1\n"); assert(x == 3); x = 4; }
	scope (failure) { printf("test2\n"); assert(x == 2); x = 3; }
	x = 2;
	throw new Eh;
	scope (failure) { printf("test3\n"); assert(x == 1); x = 2; }
	printf("test4\n"); assert(x == 0); x = 1;
    }
    catch (Eh e)
    {
    }
    assert(x == 4);
}

/********************************************/

void test7()
{   int i;
    int x;

    void foo()
    {
	scope (success) { assert(x == 1); x = 2; }
	i = 2;
	if (i == 2)
	    return;
    }

    i = 1;
    x = 1;
    foo();
    assert(x == 2);
}

/********************************************/


void test8()
{
    int i;
    {
	version (all)
	{
	    scope (exit) i += 2;
	}
	assert(i == 0);
	i += 1;
	printf("betty\n");
    }
    assert(i == 3);
}

/********************************************/

char[] r9;

int scp( int n )
{
    if( n==0 ) return 0;
    scope(exit)
    {	printf("%d",n);
	r9 ~= cast(char)(n + '0');
    }
    return scp(n-1);
}

void test9()
{
    scp(5);
    assert(r9 == "12345");
}

/********************************************/

void main()
{
    test1();
    test2();
    test3();
    test4();
    test5();
    test6();
    test7();
    test8();
    test9();

    printf("Success\n");
}
