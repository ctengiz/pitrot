<tfoot>
<tr>
    <td colspan="{{col_count}}" class="ts-pager form-inline">
        <div class="form-group">
            <button type="button" class="btn first"><i class="icon-step-backward glyphicon glyphicon-step-backward"></i></button>
            <button type="button" class="btn prev"><i class="icon-arrow-left glyphicon glyphicon-backward"></i></button>
            <span class="pagedisplay"></span> <!-- this can be any element, including an input -->
            <button type="button" class="btn next"><i class="icon-arrow-right glyphicon glyphicon-forward"></i></button>
            <button type="button" class="btn last"><i class="icon-step-forward glyphicon glyphicon-step-forward"></i></button>
        </div>
        <div class="form-group">
            <select class="pagesize input-mini form-control" title="Select page size">
                <option selected="selected" value="10">10</option>
                <option value="20">20</option>
                <option value="30">30</option>
                <option value="40">40</option>
                <option value="40">50</option>
                <option value="10000000">{{_('All')}}</option>
            </select>
        </div>
        <div class="form-group">
            <select class="pagenum input-mini form-control" title="Select page number"></select>
        </div>
    </td>
</tr>
</tfoot>
