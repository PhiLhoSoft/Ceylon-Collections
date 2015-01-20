import ceylon.collection
{
	ArrayList
}

shared class PseudoRandomDataProvider(String randomnessSource)
{
	value splitted = ArrayList { elements = randomnessSource.split(); };

	variable Integer indexWord = 0;
	variable Integer indexLetter = 0;

	shared String nextWord()
	{
		if (indexWord >= splitted.size)
		{
			indexWord = 0;
		}
		value nw = splitted[indexWord++];
		assert(exists nw);
		return nw;
	}

	shared Integer nextInteger()
	{
		if (indexLetter >= randomnessSource.size)
		{
			indexLetter = 0;
		}
		value nc = randomnessSource[indexLetter++];
		assert(exists nc);
		return nc.integer;
	}

	shared Float nextFloat()
	{
		variable value n = nextInteger();
		n %= 255; // Assume Ascii, enforce this
		if (n < 32)
		{
			n = 33 + n * 7;
		}
		return (n - 32) / (255.0 - 32);
	}
}
