pizzaclub.smc: pizzaclub.asm pizzaclub.link
	wla-65816 -vo pizzaclub.asm pizzaclub.obj
	wlalink -vr pizzaclub.link pizzaclub.smc
