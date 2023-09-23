// 3rd_party_lib:xml4cj/build/xml4cj
from xml4cj import xml4cj.*
from fuzz import fuzz.*




var flag:Int32=0
public func parse(dp:DataProvider):Int32 {

    var a:String=dp.consumeString(10)
    var b = a.replace("\n","")
    if (b.isEmpty() || b.contains("<") || b.contains(">")) {
        return flag
    }
    try{
        var xmlpar:XmlParser=XmlParser()
        xmlpar.parse(b)
    }catch (e:Exception) {
        flag=-1
    }
    return flag
}

main(){

    Fuzzer(parse).startFuzz()
        return 0

}