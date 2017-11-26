var constantize = (obj) =>{
	Object.freeze(obj);
	Object.key(obj).forEach(key,value) => {
		if(type obj[key] === 'object'){
			constantize(obj[key]);
		}
	}
}