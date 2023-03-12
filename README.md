# gcd-computation
Using datapath and controller  method , GCD computator is designed.
We have	consider	a	simple	algorithm	using	 repeated	subtraction.	
We have	identifed	the	functional	blocks	required	in	the	data	path,	and	the	corresponding	control	signals.	
Then	we	design	the	FSM	to	implement	the	GCD	computation	algorithm	using	the	data	path.

# Schematic
![sche](https://user-images.githubusercontent.com/99884583/224537058-59650475-d74d-4fde-af72-81d47744072b.png)

In the above schematic the functional blocks like A, B, S, mux1, mux2, load_mux comparator etc are designed in the datapath block. The control signals like lda, ldb, sel_in, sel1, sel2 were given to the data path design through controller path design. The signal  lt, gt, eq  were the status signal given by datapath block to the controller block.

# Output
![output](https://user-images.githubusercontent.com/99884583/224537093-a18afe5e-bbc6-463d-800b-643ff199e20a.png)
