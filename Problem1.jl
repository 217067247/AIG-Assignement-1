### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ e1dd1120-b3eb-11eb-1a53-37be649df3ae
using Pkg

# ╔═╡ 723bd564-7060-4831-9266-4f8c1f3bed82
Pkg.activate("Project.toml")

# ╔═╡ 5c2ef60d-c8b9-41b1-9303-f8df1ef7c007
using PlutoUI

# ╔═╡ cf684365-ba9a-4f17-941c-63844b5dfe23
using StaticArrays

# ╔═╡ a5f6e85f-f7b7-4977-af72-8db3494197c6
struct Action
	name::String
	cost::Int64
end

# ╔═╡ d24248ea-b5c6-459c-8375-b0c6c1fe114a
mutable struct Office
	name::String
	items::Int64
	position::Int64
end

# ╔═╡ 92ed4b6a-51e1-468a-9896-aa97898db708
MW = Action("Move West", 3)

# ╔═╡ b0f3872f-b7f9-449b-b595-e45cd7422c74
ME = Action("Move East", 3)

# ╔═╡ fffeba80-e55e-4b06-9c4b-5e8d08f6a468
CO = Action("Collect", 5)

# ╔═╡ 37f32087-72b4-465e-b4d2-7cbd776a682a
RE = Action("Remain", 1)

# ╔═╡ 2bac956d-c1d4-4f54-9d00-be233b2aac1b
W = Office("West Office", 1, 1)

# ╔═╡ 5b210a33-daee-4396-a3e9-03052bda5020
C1 = Office("Center One Office", 3, 2)

# ╔═╡ 003b0d5d-153f-4bdd-a8c8-92a4f7263629
C2 = Office("Center Two Office", 2, 3)

# ╔═╡ 863379b6-9911-4aed-8b0b-58c73f18c780
E = Office("East Office", 1, 4)

# ╔═╡ 2fb5c3af-fc13-4e9c-9efe-25e7b5ac4e82
Offices = [W,C1,C2,E]

# ╔═╡ a95697e7-959b-4e3a-b56e-36fade67081c
function Acting(Parent, Neighbour, itemNo)
	act = " "
	if itemNo == 0
		if Neighbour == Offices[1]
			act = MW.name *" "* RE.name
		end
		if Neighbour == Offices[4]
			act = ME.name *" "* RE.name
		end
		if Neighbour == Offices[2]
			if Parent == Offices[1]
				act = MW.name
			end
		end
		if Neighbour == Offices[2]
			if Parent == Offices[3]
				act = ME.name
			end
		end
		if Neighbour == Offices[3]
			if Parent == Offices[2]
				act = MW.name
			end
		end
		if Neighbour == Offices[3]
			if Parent == Offices[4]
				act = ME.name
			end
		end
	end
	if itemNo > 0
		if Neighbour == Offices[1]
			act = MW.name *" "* CO.name *" "* RE.name
		end
		if Neighbour == Offices[4]
			act = ME.name *" "* CO.name *" "* RE.name
		end
		if Neighbour == Offices[2]
			if Parent == Offices[1]
				act = MW.name  *" "* CO.name
			end
		end
		if Neighbour == Offices[2]
			if Parent == Offices[3]
				act = ME.name  *" "* CO.name
			end
		end
		if Neighbour == Offices[3]
			if Parent == Offices[2]
				act = MW.name  *" "* CO.name
			end
		end
		if Neighbour == Offices[3]
			if Parent == Offices[4]
				act = ME.name  *" "* CO.name
			end
		end
	end
	return act
end

# ╔═╡ 2bdea3c6-3549-45af-ab3e-4e4a8213fe60
function Cost(Parent, Neighbour, itemNo)
	cost = 0
	if itemNo == 0
		if Neighbour == Offices[1]
			cost = MW.cost + RE.cost
		end
		if Neighbour == Offices[4]
			cost = ME.cost + RE.cost
		end
		if Neighbour == Offices[2]
			if Parent == Offices[1]
				cost = MW.cost
			end
		end
		if Neighbour == Offices[2]
			if Parent == Offices[3]
				cost = ME.cost
			end
		end
		if Neighbour == Offices[3]
			if Parent == Offices[2]
				cost = MW.cost
			end
		end
		if Neighbour == Offices[3]
			if Parent == Offices[4]
				cost = ME.cost
			end
		end
	end
	if itemNo > 0
		if Neighbour == Offices[1]
			cost = MW.cost + CO.cost + RE.cost
		end
		if Neighbour == Offices[4]
			cost = ME.cost + CO.cost + RE.cost
		end
		if Neighbour == Offices[2]
			if Parent == Offices[1]
				cost = MW.cost + CO.cost
			end
		end
		if Neighbour == Offices[2]
			if Parent == Offices[3]
				cost = ME.cost + CO.cost
			end
		end
		if Neighbour == Offices[3]
			if Parent == Offices[2]
				cost = MW.cost + CO.cost
			end
		end
		if Neighbour == Offices[3]
			if Parent == Offices[4]
				cost = ME.cost + CO.cost
			end
		end
	end
	return cost
end

# ╔═╡ d9fb1c05-3fce-41e8-89d0-363f33f08194
function Distance(Indx, goal)
	dist = Offices[goal].position - Offices[Indx].position
	return dist
end

# ╔═╡ fd9e15cc-b158-4c54-a472-b92547870b3b
function Decide(Node1, Node2, a, b)
	dc = 0
	if (Offices[Node1] == Offices[1])&&(Offices[1].items == 0)
		dc = Node2
	elseif (Offices[Node2] == Offices[4])&&(Offices[4].items == 0)
		dc = Node1
	else
		if (Offices[Node2] == Offices[2])&&(Offices[Node1].items == 0)&&(Offices[Node1 - 1].items == 0)
			dc = Node2
		elseif (Offices[Node2] == Offices[3])&&(Offices[Node2].items == 0)&&(Offices[Node2 + 1].items == 0)
			dc = Node1
		else
			if a > b
				dc = Node2
			elseif a < b
				dc = Node1
			else
				if Offices[Node1].position > Offices[Node2].position
					dc = Node2
				else
					dc = Node1
				end
			end
		end
	end
	return dc
end

# ╔═╡ 923bd5c1-a170-4f0a-83e3-283df817690f
function Pathing(C1i,Ei)
	opQ = []
	prI = C1i
	hue = Offices[1].items + Offices[2].items + Offices[3].items + Offices[4].items
	while hue > 0
		currIndx = prI
		if Offices[currIndx] == Offices[1]
			if Offices[currIndx].items > 0
				Offices[currIndx].items = Offices[currIndx].items - 1
			end
			nxtOf = currIndx + 1
			ac = Acting(Offices[currIndx], Offices[nxtOf], Offices[nxtOf].items)
			push!(opQ, ac)
			prI = nxtOf
		end
		if Offices[currIndx] == Offices[4]
			if Offices[currIndx].items > 0
				Offices[currIndx].items = Offices[currIndx].items - 1
			end
			nxtOf = currIndx - 1
			ac = Acting(Offices[currIndx], Offices[nxtOf], Offices[nxtOf].items)
			push!(opQ, ac)
			prI = nxtOf
		end
		if (Offices[currIndx] == Offices[3])||(Offices[currIndx] == Offices[2])
		if Offices[currIndx].items > 0
			Offices[currIndx].items = Offices[currIndx].items - 1
		end
		nO1 = currIndx - 1
		nO2 = currIndx + 1
		a1 = Cost(Offices[currIndx], Offices[nO1], Offices[nO1].items)
		a2 = Distance(nO1, Ei)
		b1 = Cost(Offices[currIndx], Offices[nO2], Offices[nO2].items)
		b2 = Distance(nO2, Ei)
		a = a1 + a2
		b = b1 + b2
			if a > b
				nxtOf = nO2
				ac = Acting(Offices[currIndx], Offices[nxtOf], Offices[nxtOf].items)
				push!(opQ, ac)
				prI = nxtOf
			end
			if a < b
				nxtOf = nO1
				ac = Acting(Offices[currIndx], Offices[nxtOf], Offices[nxtOf].items)
				push!(opQ, ac)
				prI = nxtOf
			end		
		end
		
	end
	return opQ
end

# ╔═╡ 3c454e9f-1ef5-4e53-8ac6-1d8b9ae35178
function Pathing2(C1i,Ei)
	opQ = []
	prI = C1i
	hue = Offices[1].items + Offices[2].items + Offices[3].items + Offices[4].items
	while hue > 0
		currIndx = prI
		if Offices[currIndx] == Offices[1]
			if Offices[currIndx].items > 0
				Offices[currIndx].items = Offices[currIndx].items - 1
			end
			nxtOf = currIndx + 1
			ac = Acting(Offices[currIndx], Offices[nxtOf], Offices[nxtOf].items)
			push!(opQ, ac)
			prI = nxtOf
		elseif Offices[currIndx] == Offices[4]
			if Offices[currIndx].items > 0
				Offices[currIndx].items = Offices[currIndx].items - 1
			end
			nxtOf = currIndx - 1
			ac = Acting(Offices[currIndx], Offices[nxtOf], Offices[nxtOf].items)
			push!(opQ, ac)
			prI = nxtOf
		else
			if Offices[currIndx].items > 0
				Offices[currIndx].items = Offices[currIndx].items - 1
			end
			nO1 = currIndx - 1
			nO2 = currIndx + 1
			a1 = Cost(Offices[currIndx], Offices[nO1], Offices[nO1].items)
			a2 = Distance(nO1, Ei)
			b1 = Cost(Offices[currIndx], Offices[nO2], Offices[nO2].items)
			b2 = Distance(nO2, Ei)
			a = a1 + a2
			b = b1 + b2
			n = Decide(nO1, nO2, a, b)
			nxtOf = n
			ac = Acting(Offices[currIndx], Offices[nxtOf], Offices[nxtOf].items)
			push!(opQ, ac)
			prI = nxtOf
		end
	end
	
end

# ╔═╡ 19649d33-79fd-4145-b7cc-5b0ae3035d63
p = Pathing(2,4)

# ╔═╡ Cell order:
# ╠═e1dd1120-b3eb-11eb-1a53-37be649df3ae
# ╠═723bd564-7060-4831-9266-4f8c1f3bed82
# ╠═5c2ef60d-c8b9-41b1-9303-f8df1ef7c007
# ╠═cf684365-ba9a-4f17-941c-63844b5dfe23
# ╠═a5f6e85f-f7b7-4977-af72-8db3494197c6
# ╠═d24248ea-b5c6-459c-8375-b0c6c1fe114a
# ╠═92ed4b6a-51e1-468a-9896-aa97898db708
# ╠═b0f3872f-b7f9-449b-b595-e45cd7422c74
# ╠═fffeba80-e55e-4b06-9c4b-5e8d08f6a468
# ╠═37f32087-72b4-465e-b4d2-7cbd776a682a
# ╠═2bac956d-c1d4-4f54-9d00-be233b2aac1b
# ╠═5b210a33-daee-4396-a3e9-03052bda5020
# ╠═003b0d5d-153f-4bdd-a8c8-92a4f7263629
# ╠═863379b6-9911-4aed-8b0b-58c73f18c780
# ╠═2fb5c3af-fc13-4e9c-9efe-25e7b5ac4e82
# ╠═a95697e7-959b-4e3a-b56e-36fade67081c
# ╠═2bdea3c6-3549-45af-ab3e-4e4a8213fe60
# ╠═d9fb1c05-3fce-41e8-89d0-363f33f08194
# ╠═fd9e15cc-b158-4c54-a472-b92547870b3b
# ╠═923bd5c1-a170-4f0a-83e3-283df817690f
# ╠═3c454e9f-1ef5-4e53-8ac6-1d8b9ae35178
# ╠═19649d33-79fd-4145-b7cc-5b0ae3035d63
