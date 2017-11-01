# 向二维dict中插入key，value
def add_to_twodimDict(mdict, first_key, second_key, val):
        """
        Insert element to tow-dimension dict
        """
        if first_key in mdict:
            mdict[first_key].update({second_key: val})
        else:
            mdict.update({first_key: {second_key: val}})