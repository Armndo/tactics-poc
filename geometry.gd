@tool
extends MeshInstance3D

func _ready():
	#
	#var mesh_data = []
	var mesh_arr = ArrayMesh.new()
	#mesh_data.resize(ArrayMesh.ARRAY_MAX)
	#
	var y = 1
	var aux_arr = []
	
	var ind = 0
	for j in range(4):
		for i in range(4):
			for k in range(4):
				var vec = Vector3(i, j, k)
				print(ind, " - ", vec)
				aux_arr.push_back(vec)
				ind += 1
	
	print(aux_arr)
	
	var vertices = PackedVector3Array(aux_arr)
	#var vertices = PackedVector3Array([
		#Vector3(0,y,0),
		#Vector3(3,y,0),
		#Vector3(3,y,3),
		#Vector3(0,y,3),
		#
		#Vector3(1,y,1),
		#Vector3(1,y,2),
		#Vector3(2,y,1),
		#Vector3(2,y,2),
		#
		#Vector3(1,y+1,1),
		#Vector3(1,y+1,2),
		#Vector3(2,y+1,1),
		#Vector3(2,y+1,2),
		#
	#])
	
	var indices = PackedInt32Array([
		0,12,15,
		0,15,3,
		5,21,6,
		21,22,6,
		6,26,10,
		26,6,22,
		5,9,25,
		25,21,5,
		9,10,26,
		26,25,9,
		21,25,26,
		26,22,21,
	])
	
	var uvs = PackedVector2Array([
		Vector2(0,0),
		Vector2(0,0),
	])
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_INDEX] = indices
	#array[Mesh.ARRAY_TEX_UV] = uvs
	
	mesh_arr.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh = mesh_arr
	
	#mesh_data[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array(
		#[
			#Vector3(0,1,0),
			#Vector3(1,1,0),
			#Vector3(1,1,1),
			#Vector3(0,1,1),
			#Vector3(0,1,0)
		#]
	#)
	#
	#mesh = ArrayMesh.new()
	#mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, mesh_data)
