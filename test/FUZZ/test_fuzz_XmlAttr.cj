// 3rd_party_lib:xml4cj/build/xml4cj
from xml4cj import xml4cj.*
from fuzz import fuzz.*




var flag:Int32=0
public func XmlAttr1(dp:DataProvider):Int32 {

    
    try{
        XmlAttr(dp.consumeString(5),dp.consumeString(5))
    }catch (e:Exception) {
        flag=-1
    }
    return flag
}

main(){

    Fuzzer(XmlAttr1).startFuzz()
        return 0

}